# MySQL dump 8.14
#
# Host: localhost    Database: lsb
#--------------------------------------------------------
# Server version	3.23.39-log

#
# Table structure for table 'Type'
#

DROP TABLE IF EXISTS Type;
CREATE TABLE Type (
  Tid int(10) NOT NULL auto_increment,
  Tname varchar(60) binary NOT NULL default '',
  Ttype enum('Intrinsic','FuncPtr','Enum','Pointer','Typedef','Struct','Union','Unknown') NOT NULL default 'Unknown',
  Tsize int(10) NOT NULL default '0',
  Tbasetype int(10) default NULL,
  Theadergroup int(10) NOT NULL default '0',
  Tcomment varchar(60) default NULL,
  Tarray varchar(16) default NULL,
  Tarch int(11) NOT NULL default '1',
  Tstatus enum('Referenced','Indirect','Excluded') NOT NULL default 'Excluded',
  PRIMARY KEY  (Tid),
  UNIQUE KEY Tname (Tname)
) TYPE=MyISAM;

