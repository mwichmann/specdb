# MySQL dump 8.16
#
# Host: localhost    Database: lsb
#--------------------------------------------------------
# Server version	3.23.43-log

#
# Table structure for table 'Library'
#

DROP TABLE IF EXISTS Library;
CREATE TABLE Library (
  Lid int(10) NOT NULL auto_increment,
  Lname varchar(60) binary NOT NULL default '',
  Lrunname varchar(60) binary NOT NULL default '',
  Lstd enum('Yes','No') NOT NULL default 'No',
  Larch int(11) NOT NULL default '1',
  PRIMARY KEY  (Lid),
  UNIQUE KEY k_lib (Lname,Lstd)
) TYPE=MyISAM;

