#!/usr/bin/python

# $Id$

__author__ = 'cveeraiyan'

import os
import sys
import time
from ConfigParser import SafeConfigParser, NoOptionError

import ipaddress

try:
    import pexpect
except ImportError:
    sys.stderr.write("Module pexpect is required. Please install using "
                     "'[sudo] pip install pexpect' or '[sudo] easy_install "
                     "pexpect'.\n")
    sys.exit(-1)



DESCRIPTION = '''

[DEFAULT]
vcenter_url = pit-vc03.cisco.com
datastore = Storage-Cluster
branch = Development
version = 6.0.0
mgmt_port = vlan3000
internal_port = 2450
external_port = 2750
ovf_url = http://install.cm.sourcefire.com
domain = cisco
user = cec-id
password = xxxxxxxx
vi_url = vi://%(domain)s%%5c%(user)s@%(password)s:%(vcenter_url)s/DramBuie-Sensors/host/DramBuie-Sensors/

[vngips]
mgmt_ip = 192.168.0.103
mgmt_mask = 255.255.255.0
mgmt_gw = 192.168.0.254
dc_ip = 192.168.0.240
dc_key = ngips
vm_folder = ST-Upgrade/vNGIPS/

[vngfw]
mgmt_ip = 192.168.0.104
mgmt_mask = 255.255.255.0
mgmt_gw = 192.168.0.254
dc_ip = 192.168.0.240
dc_key = ngfw
vm_folder = ST-Upgrade/vNGFW/

'''

def load_vngfw_ova(cfg,vmNumber,mgmtip,inp,outp,version,build,branch):

    mgmtip_octets= mgmtip.split('.')
    #print (mgmtip_octets)

    for count in range(0,vmNumber):
       '''
       print ("ovftool --acceptAllEulas --overwrite --powerOffTarget --powerOn --allowExtraConfig --name=vNGFW_%s_%s "\
          "--datastore=%s --vmFolder=%s --diskMode=thin --net:GigabitEthernet0-0=Sensor-%s-%s-IN-%d --net:GigabitEthernet0-1=Sensor-%s-%s-OUT-%d  --net:GigabitEthernet0-2=Holding --net:Management0-0=%s " \
          "--prop:fqdn=vNGFW --prop:pw=Admin123 --prop:dns1=192.168.0.184 --prop:ipv4.how=Manual --prop:ipv4.addr=%s " \
          "--prop:ipv4.mask=%s --prop:ipv4.gw=%s --prop:firewallmode=routed --prop:mgr=%s " \
          "--prop:regkey=%s %s/%s/%s-%s/virtual-ngfw/Cisco_Firepower_Threat_Defense_Virtual-VI-%s-%s.ovf %s" \
           % (mgmtip_octets[2],mgmtip_octets[3],cfg.datastore,cfg.vm_folder,mgmtip_octets[2],mgmtip_octets[3],int(inp)+count,mgmtip_octets[2],mgmtip_octets[3],int(outp)+count,
            cfg.mgmt_port,mgmtip,cfg.mgmt_mask,cfg.mgmt_gw,cfg.dc_ip,cfg.dc_key,cfg.ovf_url,branch,version,build,version,build,cfg.vi_url))
'''
       os.system ("ovftool --acceptAllEulas --overwrite --powerOffTarget --powerOn --allowExtraConfig --name=vNGFW_%s_%s "\
          "--datastore=%s --vmFolder=%s --diskMode=thin --net:GigabitEthernet0-0=Sensor-%s-%s-IN-%d --net:GigabitEthernet0-1=Sensor-%s-%s-OUT-%d  --net:GigabitEthernet0-2=Holding --net:Management0-0=%s " \
          "--prop:fqdn=vNGFW --prop:pw=Admin123 --prop:dns1=192.168.0.184 --prop:ipv4.how=Manual --prop:ipv4.addr=%s " \
          "--prop:ipv4.mask=%s --prop:ipv4.gw=%s --prop:firewallmode=routed --prop:mgr=%s " \
          "--prop:regkey=%s %s/%s/%s-%s/virtual-ngfw/Cisco_Firepower_Threat_Defense_Virtual-VI-%s-%s.ovf %s" \
           % (mgmtip_octets[2],mgmtip_octets[3],cfg.datastore,cfg.vm_folder,mgmtip_octets[2],mgmtip_octets[3],int(inp)+count,mgmtip_octets[2],mgmtip_octets[3],int(outp)+count,
            cfg.mgmt_port,mgmtip,cfg.mgmt_mask,cfg.mgmt_gw,cfg.dc_ip,cfg.dc_key,cfg.ovf_url,branch,version,build,version,build,cfg.vi_url))

       mgmtip=str(ipaddress.ip_address(unicode(mgmtip)) + 1)
       mgmtip_octets= mgmtip.split('.')
       #print (mgmtip_octets)


def load_vngips_ovf(cfg,vmNumber,mgmtip,inp,outp,version,build,branch):
    mgmtip_octets= mgmtip.split('.')
    for count in range(0,vmNumber):

        print ("ovftool --acceptAllEulas --overwrite --powerOffTarget --allowExtraConfig --powerOn --name=vNGIPS_%s_%s "\
          "--datastore=%s --vmFolder=%s --diskMode=thin --net:Internal=Sensor-%s-%s-IN-%d --net:External=Sensor-%s-%s-OUT-%d --net:Management=%s " \
          "--prop:fqdn=vNGIPS --prop:pw=Admin123 --prop:dns1=192.168.0.184 --prop:ipv4.how=Manual --prop:ipv4.addr=%s " \
          "--prop:ipv4.mask=%s --prop:ipv4.gw=%s --prop:mode=Inline --prop:mgr=%s " \
          "--prop:regkey=%s %s/%s/%s-%s/virtual-appliance/VMWARE/Cisco_Firepower_NGIPSv_VMware-VI-%s-%s.ovf %s" \
           %
(mgmtip_octets[2],mgmtip_octets[3],cfg.datastore,cfg.vm_folder,mgmtip_octets[2],mgmtip_octets[3],int(inp)+count,mgmtip_octets[2],mgmtip_octets[3],int(outp)+count,
            cfg.mgmt_port,mgmtip,cfg.mgmt_mask,cfg.mgmt_gw,cfg.dc_ip,cfg.dc_key,cfg.ovf_url,branch,version,build,version,build,cfg.vi_url))

        os.system("ovftool --acceptAllEulas --overwrite --powerOffTarget --allowExtraConfig --powerOn --name=vNGIPS_%s_%s "\
          "--datastore=%s --vmFolder=%s --diskMode=thin --net:Internal=Sensor-%s-%s-IN-%d  --net:External=Sensor-%s-%s-OUT-%d --net:Management=%s "\
          "--prop:fqdn=vNGIPS --prop:pw=Admin123 --prop:dns1=192.168.0.184 --prop:ipv4.how=Manual --prop:ipv4.addr=%s "\
          "--prop:ipv4.mask=%s --prop:ipv4.gw=%s --prop:mode=Inline --prop:mgr=%s "\
          "--prop:regkey=%s %s/%s/%s-%s/virtual-appliance/VMWARE/Cisco_Firepower_NGIPSv_VMware-VI-%s-%s.ovf %s"\
           % (mgmtip_octets[2],mgmtip_octets[3],cfg.datastore,cfg.vm_folder,mgmtip_octets[2],mgmtip_octets[3],int(inp)+count,mgmtip_octets[2],mgmtip_octets[3],int(outp)+count,
            cfg.mgmt_port,mgmtip,cfg.mgmt_mask,cfg.mgmt_gw,cfg.dc_ip,cfg.dc_key,cfg.ovf_url,branch,version,build,version,build,cfg.vi_url))

        mgmtip=str(ipaddress.ip_address(unicode(mgmtip)) + 1)
        mgmtip_octets= mgmtip.split('.')


class DeviceConfig(object):

    def __init__(self, device_type,configfile=os.path.expanduser('~/deploy/pit-vc03.cfg')):
        config = SafeConfigParser()
        config.read(configfile)


        self.ovf_url = config.get('DEFAULT', 'ovf_url')
        self.vi_url = config.get('DEFAULT', 'vi_url')
        self.vcenter_url = config.get('DEFAULT', 'vcenter_url')
        self.datastore = config.get('DEFAULT', 'datastore')
        self.branch = config.get('DEFAULT', 'branch')
        self.version = config.get('DEFAULT', 'version')
        self.build = config.get('DEFAULT', 'build')

        self.mgmt_port = config.get('DEFAULT', 'mgmt_port')
        self.internal_port = config.get(device_type, 'internal_port')
        self.external_port = config.get(device_type, 'external_port')

        self.mgmt_ip = config.get(device_type, 'mgmt_ip')
        self.mgmt_mask = config.get(device_type, 'mgmt_mask')
        self.mgmt_gw = config.get(device_type, 'mgmt_gw')

        self.dc_ip = config.get(device_type, 'dc_ip')
        self.dc_key = config.get(device_type, 'dc_key')
        self.vm_folder = config.get(device_type, 'vm_folder')

def parse_args():
    try:
        import argparse
    except ImportError:
        sys.stderr.write("Module argparse is required. Please install using "
                         "'[sudo] pip install argparse' or '[sudo] "
                         "easy_install argparse'.\n")
        sys.exit(-1)
    parser = argparse.ArgumentParser(description=DESCRIPTION,formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('device_type', help='Device type to installed')
    parser.add_argument('--build', help='name of the vNGIPS build')
    parser.add_argument('--version', help='Name of the vNGIPS version (optional)')
    parser.add_argument('--branch', help='Name of the branch (optional)')
    parser.add_argument('--number', type=int,help='Number of VMs (optional)')
    parser.add_argument('--startIp', help='Starting Management IP(optional)')
    parser.add_argument('--startPort', help='Starting Input Port(optional)')
    parser.add_argument('--um-ip', help='Unified Management IP (optional)')

    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    cfg = DeviceConfig(args.device_type)

    numberOfVMs = 1

    if args.number:
     numberOfVMs = args.number

    if args.startIp:
      deviceMgmtIp=args.startIp
    else:
      deviceMgmtIp=cfg.mgmt_ip

    if args.startPort:
      inPort=args.startPort
      outPort=int(args.startPort)+300
    else:
      inPort=cfg.internal_port
      outPort=cfg.external_port

    if args.version:
      version=args.version
    else:
      version=cfg.version

    if args.build:
      build=args.build
    else:
      build=cfg.build

    if args.branch:
      branch=args.branch
    else:
      branch=cfg.branch

    if args.device_type == 'vngips':
        return load_vngips_ovf(cfg,numberOfVMs,deviceMgmtIp,inPort,outPort,version,build,branch)
    elif args.device_type == 'vngfw':
        return load_vngfw_ova(cfg,numberOfVMs,deviceMgmtIp,inPort,outPort,version,build,branch)


if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(1)

