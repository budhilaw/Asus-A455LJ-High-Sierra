/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20170929 (64-bit version)(RM)
 * Copyright (c) 2000 - 2017 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-1-zpodd.aml, Mon Dec  4 17:09:08 2017
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000194 (404)
 *     Revision         0x01
 *     Checksum         0xDD
 *     OEM ID           "Intel"
 *     OEM Table ID     "zpodd"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120913 (538052883)
 */
DefinitionBlock ("", "SSDT", 1, "Intel", "zpodd", 0x00001000)
{
    External (_SB_.PCI0.SATA, DeviceObj)
    External (_SB_.PCI0.SATA.PRT1, DeviceObj)
    External (_SB_.WTGP, MethodObj)    // 2 Arguments
    External (ADBG, MethodObj)    // 1 Arguments
    External (BID_, FieldUnitObj)
    External (GO17, FieldUnitObj)
    External (RTD3, FieldUnitObj)

    If (LAnd (LOr (LEqual (BID, 0x20), LEqual (BID, 0x24)), LEqual (RTD3, Zero)))
    {
        Scope (\_SB.PCI0.SATA)
        {
            Scope (PRT1)
            {
                Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
                {
                    If (LEqual (Arg0, ToUUID ("bdfaef30-aebb-11de-8a39-0800200c9a66")))
                    {
                        Switch (ToInteger (Arg2))
                        {
                            Case (Zero)
                            {
                                ADBG ("Case 0")
                                Switch (ToInteger (Arg1))
                                {
                                    Case (One)
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x0F                                           
                                        })
                                    }
                                    Default
                                    {
                                        Return (Buffer (One)
                                        {
                                             0x00                                           
                                        })
                                    }

                                }
                            }
                            Case (One)
                            {
                                ADBG ("Enable ZPODD")
                                Return (One)
                            }
                            Case (0x02)
                            {
                                ADBG ("Power OFF Device")
                                \_SB.WTGP (0x46, One)
                                Store (Zero, \GO17)
                                Return (One)
                            }
                            Case (0x03)
                            {
                                ADBG ("Power ON Device")
                                \_SB.WTGP (0x46, Zero)
                                Store (One, \GO17)
                                Sleep (0x0A)
                                Return (One)
                            }
                            Default
                            {
                                Return (Zero)
                            }

                        }
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
            }
        }

        Scope (\_GPE)
        {
            Method (_L11, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                ADBG ("L11 Notify")
                Store (One, \GO17)
                Notify (\_SB.PCI0.SATA, 0x81)
            }
        }
    }
}

