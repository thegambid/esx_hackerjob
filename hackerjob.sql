INSERT INTO `items` (`id`, `name`, `label`, `limit`, `rare`, `can_remove`) VALUES
(0, 'kazikazan', 'Kazı Kazan', -1, 0, 1),


INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('hackerjob', 'Hacker', 1);



INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(987, 'hackerjob', 0, 'hacker', 'hacker', 0, '{}', '{}');