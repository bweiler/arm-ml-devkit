#----------------------------------------------------------------------------
#  SPDX-FileCopyrightText: Copyright 2021, 2024 Arm Limited and/or its
#  affiliates <open-source-office@arm.com>
#  SPDX-License-Identifier: Apache-2.0
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# CMake description file for the Arm Ethos-U55 Timing Adapter settings (single
# NPU core with two AXIs).
#----------------------------------------------------------------------------

# The platform CMake infra should set the base register values for
# TA component to work. For Ethos-U55, we need two base addresses.
if (NOT DEFINED TA0_BASE OR NOT DEFINED TA1_BASE)
    message(FATAL_ERROR "TA0_BASE and TA1_BASE need to be defined.")
endif ()

message(STATUS "using TA0_BASE @ ${TA0_BASE}; TA1_BASE @ ${TA1_BASE}.")

# Timing adapter settings for AXI0
set(TA0_MAXR        "8"        CACHE STRING "6-bit field. Max no. of pending reads. 0=infinite")
set(TA0_MAXW        "8"        CACHE STRING "6-bit field. Max no. of pending writes. 0=infinite")
set(TA0_MAXRW       "0"        CACHE STRING "6-bit field. Max no. of pending reads+writes. 0=infinite")
set(TA0_RLATENCY    "32"       CACHE STRING "12-bit field. Minimum latency (clock cycles) from AVALID to RVALID.")
set(TA0_WLATENCY    "32"       CACHE STRING "12-bit field. Minimum latency (clock cycles) from WVALID&WLAST to BVALID.")
set(TA0_PULSE_ON    "3999"     CACHE STRING "No. of cycles addresses let through (0-65535).")
set(TA0_PULSE_OFF   "1"        CACHE STRING "No. of cycles addresses blocked (0-65535).")
set(TA0_BWCAP       "4000"     CACHE STRING "16-bit field. Max no. of 64-bit words transfered per pulse cycle 0=infinite")
set(TA0_PERFCTRL    "0"        CACHE STRING "6-bit field selecting an event for event counter 0=default")
set(TA0_PERFCNT     "0"        CACHE STRING "32-bit event counter")
set(TA0_MODE        "1"        CACHE STRING "Bit 0: 1=enable dynamic clocking to avoid underrun;
                                             Bit 1: 1=enable random AR reordering (0=default);
                                             Bit 2: 1=enable random R reordering (0=default);
                                             Bit 3: 1=enable random B reordering (0=default);
                                             Bit 11-4: Frequency scale 0=full speed, 255=(1/256) speed")
set(TA0_HISTBIN     "0"        CACHE STRING "Controls which histogram bin (0-15) that should be accessed by HISTCNT.")
set(TA0_HISTCNT     "0"        CACHE STRING "32-bit field. Read/write the selected histogram bin.")

# Timing adapter settings for AXI1
# If Memory mode is Sram_Only Timing adapter settings for AXI1 need to match the same as AXI0
if (ETHOS_U_NPU_MEMORY_MODE STREQUAL Sram_Only)
    set(TA1_MAXR        ${TA0_MAXR}         CACHE STRING "6-bit field. Max no. of pending reads. 0=infinite")
    set(TA1_MAXW        ${TA0_MAXW}         CACHE STRING "6-bit field. Max no. of pending writes. 0=infinite")
    set(TA1_MAXRW       ${TA0_MAXRW}        CACHE STRING "6-bit field. Max no. of pending reads+writes. 0=infinite")
    set(TA1_RLATENCY    ${TA0_RLATENCY}     CACHE STRING "12-bit field. Minimum latency (clock cycles) from AVALID to RVALID.")
    set(TA1_WLATENCY    ${TA0_WLATENCY}     CACHE STRING "12-bit field. Minimum latency (clock cycles) from WVALID&WLAST to BVALID.")
    set(TA1_PULSE_ON    ${TA0_PULSE_ON}     CACHE STRING "No. of cycles addresses let through (0-65535).")
    set(TA1_PULSE_OFF   ${TA0_PULSE_OFF}    CACHE STRING "No. of cycles addresses blocked (0-65535).")
    set(TA1_BWCAP       ${TA0_BWCAP}        CACHE STRING "16-bit field. Max no. of 64-bit words transfered per pulse cycle 0=infinite")
    set(TA1_PERFCTRL    ${TA0_PERFCTRL}     CACHE STRING "6-bit field selecting an event for event counter 0=default")
    set(TA1_PERFCNT     ${TA0_PERFCNT}      CACHE STRING "32-bit event counter")
    set(TA1_MODE        ${TA0_MODE}         CACHE STRING "Bit 0: 1=enable dynamic clocking to avoid underrun;
                                                          Bit 1: 1=enable random AR reordering (0=default);
                                                          Bit 2: 1=enable random R reordering (0=default);
                                                          Bit 3: 1=enable random B reordering (0=default);
                                                          Bit 11-4: Frequency scale 0=full speed, 255=(1/256) speed")
    set(TA1_HISTBIN     ${TA0_HISTBIN}      CACHE STRING "Controls which histogram bin (0-15) that should be accessed by HISTCNT.")
    set(TA1_HISTCNT     ${TA0_HISTCNT}      CACHE STRING "32-bit field. Read/write the selected histogram bin.")
else ()
    set(TA1_MAXR        "2"       CACHE STRING "6-bit field. Max no. of pending reads. 0=infinite")
    set(TA1_MAXW        "0"       CACHE STRING "6-bit field. Max no. of pending writes. 0=infinite")
    set(TA1_MAXRW       "0"       CACHE STRING "6-bit field. Max no. of pending reads+writes. 0=infinite")
    set(TA1_RLATENCY    "64"      CACHE STRING "12-bit field. Minimum latency (clock cycles) from AVALID to RVALID.")
    set(TA1_WLATENCY    "0"       CACHE STRING "12-bit field. Minimum latency (clock cycles) from WVALID&WLAST to BVALID.")
    set(TA1_PULSE_ON    "320"     CACHE STRING "No. of cycles addresses let through (0-65535).")
    set(TA1_PULSE_OFF   "80"      CACHE STRING "No. of cycles addresses blocked (0-65535).")
    set(TA1_BWCAP       "50"      CACHE STRING "16-bit field. Max no. of 64-bit words transfered per pulse cycle 0=infinite")
    set(TA1_PERFCTRL    "0"       CACHE STRING "6-bit field selecting an event for event counter 0=default")
    set(TA1_PERFCNT     "0"       CACHE STRING "32-bit event counter")
    set(TA1_MODE        "1"       CACHE STRING "Bit 0: 1=enable dynamic clocking to avoid underrun;
                                                Bit 1: 1=enable random AR reordering (0=default);
                                                Bit 2: 1=enable random R reordering (0=default);
                                                Bit 3: 1=enable random B reordering (0=default);
                                                Bit 11-4: Frequency scale 0=full speed, 255=(1/256) speed")
    set(TA1_HISTBIN     "0"       CACHE STRING "Controls which histogram bin (0-15) that should be accessed by HISTCNT.")
    set(TA1_HISTCNT     "0"       CACHE STRING "32-bit field. Read/write the selected histogram bin.")
endif ()