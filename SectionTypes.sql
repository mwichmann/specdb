# MySQL dump 8.16
#
# Host: localhost    Database: lsb
#--------------------------------------------------------
# Server version	3.23.45-log

#
# Table structure for table 'SectionTypes'
#

DROP TABLE IF EXISTS SectionTypes;
CREATE TABLE SectionTypes (
  STid int(10) NOT NULL auto_increment,
  STname varchar(60) NOT NULL default '',
  STvalue int(10) unsigned NOT NULL default '0',
  STstandard int(10) NOT NULL default '0',
  STdescription varchar(250) default NULL,
  STarch int(11) NOT NULL default '1',
  PRIMARY KEY  (STid),
  UNIQUE KEY k_STvalue (STvalue),
  UNIQUE KEY k_STname (STname(20))
) TYPE=MyISAM;

