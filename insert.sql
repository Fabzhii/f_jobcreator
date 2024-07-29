CREATE TABLE `f_job_marker` (
  `job` varchar(30) DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `name` varchar(30) DEFAULT 'n/A',
  `identifier` int(11) DEFAULT NULL,
  `mingrade` int(11) DEFAULT 0,
  `position` longtext DEFAULT '[]',
  `marker` longtext DEFAULT '{"id":21,"color":{"g":255,"r":255,"b":255},"size":1.0}',
  `storemarker` longtext DEFAULT '{"id":25,"color":{"r":255,"b":255,"g":255},"size":3.0}',
  `weapons` longtext DEFAULT '[]',
  `items` longtext DEFAULT '[]',
  `storage` longtext DEFAULT '{"weight":0,"slots":0,"use":false}',
  `armor` longtext DEFAULT '[]',
  `vehicles` longtext DEFAULT '[]',
  `garage_type` varchar(30) DEFAULT 'car',
  `bosssettings` longtext DEFAULT '[]',
  `outfits` longtext DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

ALTER TABLE `f_job_marker`
  ADD PRIMARY KEY (`identifier`);

ALTER TABLE `jobs` ADD COLUMN `actions` longtext DEFAULT '{"revive":false,"handcuff":false,"check_identity":false,"heal_small":false,"get_license":false,"search":false,"open_vehicle":false,"carry":false,"ziptie":false,"heal_big":false,"release":false,"vehicle":false,"repair_vehicle":false,"give_license":false,"delete_vehicle":false,"billing":false,"zone":false}';
ALTER TABLE `jobs` ADD COLUMN `money` int(11) DEFAULT 0;
ALTER TABLE `jobs` ADD COLUMN `offduty` int(11) DEFAULT 0;



