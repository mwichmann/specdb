-- MySQL dump 9.08
--
-- Host: base1.freestandards.org    Database: lsb
---------------------------------------------------------

--
-- Table structure for table 'BaseTypes'
--

DROP TABLE IF EXISTS BaseTypes;
CREATE TABLE BaseTypes (
  BTcid int(11) NOT NULL default '0',
  BTpos int(11) NOT NULL default '0',
  BTrttiid int(11) NOT NULL default '0',
  PRIMARY KEY  (BTcid,BTpos)
) TYPE=MyISAM;
