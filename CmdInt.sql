-- MySQL dump 9.07
--
-- Host: localhost    Database: lsb
---------------------------------------------------------

--
-- Table structure for table 'CmdInt'
--

DROP TABLE IF EXISTS CmdInt;
CREATE TABLE CmdInt (
  CIcid int(11) NOT NULL default '0',
  CIiid int(11) NOT NULL default '0',
  CIvid int(11) NOT NULL default '0',
  UNIQUE KEY k_CI (CIcid,CIiid,CIvid)
) TYPE=MyISAM;

