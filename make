#!/bin/sh
../pasmo-0.5.5/pasmo --name LCycle --tap main.asm lcycle.tap lcycle.log
../pasmo-0.5.5/pasmo --name Interrupt --tap interrupt.asm interrupt.tap interrupt.log

cat loader.tap lcycle.tap interrupt.tap > LightCycle.tap
