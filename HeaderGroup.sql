-- MySQL dump 8.23
--
-- Host: base1.freestandards.org    Database: lsb
---------------------------------------------------------

--
-- Table structure for table `HeaderGroup`
--

DROP TABLE IF EXISTS HeaderGroup;
CREATE TABLE HeaderGroup (
  HGid int(10) NOT NULL auto_increment,
  HGname varchar(60) NOT NULL default '',
  HGheader int(10) NOT NULL default '0',
  HGorder int(10) NOT NULL default '0',
  HGarch int(10) NOT NULL default '1',
  HGdescription text,
  PRIMARY KEY  (HGid)
) TYPE=MyISAM;

