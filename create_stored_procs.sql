SET SESSION myisam_sort_buffer_size = 30 * 1024 * 1024;

delimiter //

DROP PROCEDURE IF EXISTS create_included_ints_table //

CREATE PROCEDURE create_included_ints_table ()
BEGIN
    DECLARE version CHAR(255);
    DECLARE arch INT(10) UNSIGNED;
    DECLARE table_name char(255);
    DECLARE table_arch_name char(255);
    DECLARE table_correspondance_name char(255);
    DECLARE done INT DEFAULT 0;
    DECLARE done_arch INT DEFAULT 0;
    DECLARE version_cur CURSOR FOR SELECT LVvalue FROM LSBVersion;
    DECLARE arch_cur CURSOR FOR SELECT Aid FROM Architecture;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

    OPEN version_cur;
    REPEAT
	FETCH version_cur INTO version;
	IF NOT done THEN
	    SET @version_name = REPLACE( version, '.', '_' );
	    SET @table_name = CONCAT( 'cache_IntsIncludedIn_', @version_name );
	    SET @stmt_text = CONCAT( "DROP TABLE IF EXISTS ", @table_name);
	    PREPARE stmt FROM @stmt_text;
	    EXECUTE stmt;
	    
	    SET @stmt_text = CONCAT( "CREATE TABLE ", @table_name,
		"(KEY `Iid` (`Iid`), KEY `Itype` (`Itype`,`Itestable`), KEY `AIarch` (`AIarch`,`Iid`), KEY `ISsid`(`ISsid`), KEY `LGIlibg` (`LGIlibg`), KEY `Lid` (`Lid`,`AIarch`), KEY `Idocumented` (`Idocumented`), KEY `AIdeprecatedsince`(`AIdeprecatedsince`) )
		SELECT Iid, AIarch, Itype, LGIlibg, LGlib AS Lid, ISsid, Itestable, Idocumented, AIdeprecatedsince FROM Interface
		LEFT JOIN ArchInt ON AIint=Iid
		LEFT JOIN IntStd ON ISiid=Iid
		LEFT JOIN LGInt ON LGIint=Iid 
		LEFT JOIN LibGroup ON LGIlibg=LGid
		WHERE AIappearedin <> '' AND AIappearedin <= '", version, "' AND (AIwithdrawnin IS NULL OR AIwithdrawnin > '", version, "')
		AND ( ISsid IS NULL OR (ISappearedin <> '' AND ISappearedin <= '", version, "' AND ISwithdrawnin IS NULL OR ISwithdrawnin > '", version, "') )");
	    PREPARE stmt FROM @stmt_text;
    	    EXECUTE stmt;
	    
	    SET @table_correspondance_name = CONCAT( @table_name, "_correspondance" );
            SET @stmt_text = CONCAT( "DROP TABLE IF EXISTS ", @table_correspondance_name);
            PREPARE stmt FROM @stmt_text;
            EXECUTE stmt;
	    
	    SET @stmt_text = CONCAT( "CREATE TABLE ", @table_correspondance_name,
		    " (PRIMARY KEY `Iid` (`Iid`,`RIid`,`AIarch`), KEY `RIid` (`RIid`), KEY `Ilibrary` (`Ilibrary`) )
		      SELECT ", @table_name, ".Iid, RIid, AIarch, Ilibrary FROM ", @table_name,
		    " LEFT JOIN cache_IntCorrespondance USING(Iid) GROUP BY ", @table_name, ".Iid, RIid, AIarch"
		);
	    PREPARE stmt FROM @stmt_text;
	    EXECUTE stmt;

	    OPEN arch_cur;
	    REPEAT
		FETCH arch_cur INTO arch;
		SET @table_arch_name = CONCAT( @table_name, "_on_", arch );
		SET @stmt_text = CONCAT( "DROP TABLE IF EXISTS ", @table_arch_name);
		PREPARE stmt FROM @stmt_text;
		EXECUTE stmt;
		
		SET @stmt_text = CONCAT( "CREATE TABLE ", @table_arch_name,
		    "(KEY `Iid` (`Iid`), KEY `Itype` (`Itype`,`Itestable`), KEY `AIarch` (`AIarch`,`Iid`), KEY `ISsid`(`ISsid`), KEY `LGIlibg` (`LGIlibg`), KEY `Lid` (`Lid`,`AIarch`), KEY `Idocumented`(`Idocumented`), KEY `AIdeprecatedsince`(`AIdeprecatedsince`))
		    SELECT Iid, max(AIarch) as AIarch, Itype, LGIlibg, Lid, ISsid, Itestable, Idocumented, AIdeprecatedsince FROM ", @table_name,
		    " WHERE AIarch=1 OR AIarch=", arch,
		    " GROUP BY Iid");
		PREPARE stmt FROM @stmt_text;
		EXECUTE stmt;

		SET @table_correspondance_name = CONCAT( @table_arch_name, "_correspondance" );
	        SET @stmt_text = CONCAT( "DROP TABLE IF EXISTS ", @table_correspondance_name);
                PREPARE stmt FROM @stmt_text;
        	EXECUTE stmt;
	    
		SET @stmt_text = CONCAT( "CREATE TABLE ", @table_correspondance_name,
			" (PRIMARY KEY `Iid` (`Iid`,`RIid`,`AIarch`), KEY `RIid` (`RIid`), KEY `Ilibrary` (`Ilibrary`) )
			  SELECT ", @table_arch_name, ".Iid, RIid, AIarch, Ilibrary FROM ", @table_arch_name,
			" LEFT JOIN cache_IntCorrespondance USING(Iid)"
		    );  
		PREPARE stmt FROM @stmt_text;
		EXECUTE stmt;
		
	    UNTIL done END REPEAT;
	    SET done = 0;
	    CLOSE arch_cur;
	    
	END IF;
    UNTIL done END REPEAT;

    CLOSE version_cur;
    
END
//

DROP PROCEDURE IF EXISTS fill_uniq_pairs_id //

CREATE PROCEDURE fill_uniq_pairs_id ()
BEGIN
    DECLARE app_id INT(10) UNSIGNED;
    DECLARE rawint_id INT(10) UNSIGNED;
    DECLARE int_id INT(10) UNSIGNED;
    DECLARE done INT DEFAULT 0;
    DECLARE uniq_id INT(10) UNSIGNED DEFAULT 1;
    DECLARE records_cur CURSOR FOR SELECT ARIaid, RIid, Iid FROM cache_AppRIntLib WHERE Iid IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    
    OPEN records_cur;
    
    REPEAT
	FETCH records_cur INTO app_id, rawint_id, int_id;
	IF NOT done THEN
	    UPDATE cache_AppRIntLib SET UniqId=uniq_id WHERE ARIaid=app_id AND RIid=rawint_id AND Iid=int_id;
	    SET uniq_id = uniq_id + 1;
	END IF;
    UNTIL done END REPEAT;
    
    CLOSE records_cur;
END
//

-- Procedure used in consistency check
DROP PROCEDURE IF EXISTS count_libs_presence //

CREATE PROCEDURE count_libs_presence ()
BEGIN
    DECLARE libname varchar(750);
    DECLARE alname varchar(750);
    DECLARE done INT DEFAULT 0;
    DECLARE cur_1 cursor for SELECT ALsoname, CONCAT(ALsoname,'%') FROM ApprovedLibrary;
    DECLARE continue handler for sqlstate '02000' set done = 1;

    SET @stmt_text = "CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Component
                        (KEY `Cid` (`Cid`))
                        SELECT IFNULL(C2.Cid,C1.Cid) AS Cid, C1.Cdistr AS Cdistr FROM Component C1
                        LEFT JOIN Component C2 ON C1.Calias=C2.Cid";
    PREPARE stmt FROM @stmt_text;
    EXECUTE stmt;

    OPEN cur_1;

    REPEAT
    fetch cur_1 into alname, libname;
        IF NOT done THEN
        SET @stmt_text = CONCAT("INSERT INTO tmp_Result
            SELECT ALsoname, ALlibname, count(distinct Cdistr) AS distr_cnt FROM ApprovedLibrary, RawLibrary
            LEFT JOIN tmp_Component ON Cid=RLcomponent
            WHERE ALsoname='", alname ,"'
            AND RLsoname LIKE '", libname, "'
            GROUP BY ALsoname ORDER BY distr_cnt DESC, ALlibname, ALsoname" );
        PREPARE stmt FROM @stmt_text;
        EXECUTE stmt;
    END IF;

    until done end REPEAT;

    close cur_1;

END
//

delimiter ;

# create cache_IntsIncludedIn* tables
CALL create_included_ints_table();

CALL fill_uniq_pairs_id();

# Clean up tables - not every architecture was present in every LSB version
DELETE FROM cache_IntsIncludedIn_1_0_on_10;
DELETE FROM cache_IntsIncludedIn_1_0_on_11;
DELETE FROM cache_IntsIncludedIn_1_0_on_12;
DELETE FROM cache_IntsIncludedIn_1_0_on_3;
DELETE FROM cache_IntsIncludedIn_1_0_on_6;
DELETE FROM cache_IntsIncludedIn_1_0_on_9;
DELETE FROM cache_IntsIncludedIn_1_1_on_10;
DELETE FROM cache_IntsIncludedIn_1_1_on_11;
DELETE FROM cache_IntsIncludedIn_1_1_on_12;
DELETE FROM cache_IntsIncludedIn_1_1_on_3;
DELETE FROM cache_IntsIncludedIn_1_1_on_6;
DELETE FROM cache_IntsIncludedIn_1_1_on_9;
DELETE FROM cache_IntsIncludedIn_1_2_on_10;
DELETE FROM cache_IntsIncludedIn_1_2_on_11;
DELETE FROM cache_IntsIncludedIn_1_2_on_12;
DELETE FROM cache_IntsIncludedIn_1_2_on_3;
DELETE FROM cache_IntsIncludedIn_1_2_on_9;
DELETE FROM cache_IntsIncludedIn_1_3_on_11;
DELETE FROM cache_IntsIncludedIn_1_3_on_9;
