#!/usr/bin/perl -w
#####################################################################
#                        ROACH2_reboot.pl
#
# This Perl script uses SNMB and the opengear PDUMIB to reboot the 
# the ROACH2s currently in DR8, without having to go through the 
# excruciatingly slow (if off-site) Web page interface.
# I will need to generalize this script as the SWARM is expanded.
#
# Initial Release									 07/012/2014
#
# Billie Chitwood:     bchitwood@cfa.harvard.edu
#####################################################################
my $sleepTime = 5; # Number of seconds to leave the outlet off before restarting.
my $returnString = `snmpget -v1  -Oa -M.:/usr/share/snmp/mibs -c public 172.22.4.63 PDU-MIB::pdu01OutletStatus.0`;
print "returnString= $returnString\n";
my @State = split(/,/, $returnString);
$State[0] = chop($State[0]);
$State[7] =  substr($State[7], 0, -2);
print "State= @State\n";
print "Enter number of ROACH2 to reboot  and return.\n(Enter 0 to reboot all).\n";
my $ROACH2num = <>; 
chomp($ROACH2num);
print "Pressed:  $ROACH2num\n";
if ($ROACH2num == 0)
		{
		system("snmpset -v1  -Oa -M.:/usr/share/snmp/mibs -c public 172.22.4.63 PDU-MIB::pdu01OutletStatus.0  s \"0,0,0,0,0,0,0,0\"");
		print "All ROACH2s off.\n";
		sleep 2;
		system("snmpset -v1  -Oa -M.:/usr/share/snmp/mibs -c public 172.22.4.63 PDU-MIB::pdu01OutletStatus.0  s \"1,1,1,1,1,1,1,1\"");
		print "All ROACH2s are back on. Give them a minute to get their IP addresses.\n";
		exit;
		}


my $Arraynum = $ROACH2num-1;
print "Rebooting ROACH2-0$ROACH2num\n";
$State[$Arraynum] = 0;			
print "State[$Arraynum]= $State[$Arraynum]\n";	
system("snmpset -v1  -Oa -M.:/usr/share/snmp/mibs -c public 172.22.4.63 PDU-MIB::pdu01OutletStatus.0  s \"$State[0],$State[1],$State[2],$State[3],$State[4],$State[5],$State[6],$State[7]\"");
print "ROACH2-0$ROACH2num off.\n";
sleep $sleepTime;
$State[$Arraynum] = 1;	
system("snmpset -v1  -Oa -M.:/usr/share/snmp/mibs -c public 172.22.4.63 PDU-MIB::pdu01OutletStatus.0  s \"$State[0],$State[1],$State[2],$State[3],$State[4],$State[5],$State[6],$State[7]\"");
print "ROACH2-0$ROACH2num back on. Give it a minute to get its IP address.\n";
									


