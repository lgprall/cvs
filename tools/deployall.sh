#!/bin/sh

./ovf_deploy.py --number=50 vngfw
./ovf_deploy.py --number=150 --startIp 192.168.4.51 --startPort 2251 vngips
./ovf_deploy.py --number=50 --startIp 192.168.4.201 vngfw
./ovf_deploy.py --number=50 --startIp 192.168.5.1 vngfw
