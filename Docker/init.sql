SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET character_set_server = 'utf8mb4';
SET GLOBAL max_allowed_packet = 1048576;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `directusv9`
--
USE `directus`;
-- --------------------------------------------------------

--
-- Table structure for table `absences`
--

CREATE TABLE IF NOT EXISTS `absences` (
`id` int(10) UNSIGNED NOT NULL,
`created_by` char(36) DEFAULT NULL,
`created_on` timestamp NULL DEFAULT NULL,
`date_of_absence` date DEFAULT NULL,
`user` int(10) UNSIGNED DEFAULT NULL,
`handled` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;	

-- --------------------------------------------------------

--
-- Table structure for table `admin_settings`
--

CREATE TABLE IF NOT EXISTS `admin_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` varchar(20) DEFAULT 'draft',
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `allowed_modules` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `admin_smartschoolimport`
--

CREATE TABLE IF NOT EXISTS `admin_smartschoolimport` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` varchar(20) DEFAULT 'draft',
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `articlecategories`
--

CREATE TABLE IF NOT EXISTS `articlecategories` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `articlecategories`
--

INSERT INTO `articlecategories` (`id`, `created_by`, `created_on`, `name`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:18', 'Eten'),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:18', 'Drinken'),
(3, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:18', 'Andere');

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE IF NOT EXISTS `articles` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `picture` char(36) DEFAULT NULL,
  `fallback_price` decimal(10,2) DEFAULT NULL,
  `vat_level` int(10) UNSIGNED DEFAULT NULL,
  `vat_included_in_price` tinyint(1) DEFAULT 1,
  `does_not_trigger_attendence` tinyint(1) DEFAULT 1,
  `no_attendence_fee` tinyint(1) DEFAULT 1,
  `active` tinyint(1) DEFAULT 1,
  `order` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `created_by`, `created_on`, `name`, `description`, `picture`, `fallback_price`, `vat_level`, `vat_included_in_price`, `does_not_trigger_attendence`, `no_attendence_fee`, `active`, `order`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Hoofdschotel', 'Hoofdschotel', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '4.50', 4, 1, 0, 1, 1, NULL),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Volledige maaltijd dagschotel', 'Volledige maaltijd dagschotel', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '6.00', 4, 1, 0, 1, 1, 0),
(3, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Betaalkaart', 'Betaalkaart', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '6.00', 4, 1, 1, 1, 1, NULL),
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Belegd broodje', 'Belegd broodje', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '2.80', 4, 1, 0, 1, 1, NULL),
(5, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Soep', 'Soep', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '1.00', 4, 1, 0, 0, 1, NULL),
(6, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Dessert', 'Dessert', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '1.00', 4, 1, 0, 0, 1, NULL),
(7, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Spa Bruis/Plat', 'Spa Bruis/Plat', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '1.00', 4, 1, 0, 0, 1, NULL),
(8, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Gearomat water', 'Gearomatiseerd water', '470a4da8-78d6-4271-8ecc-a4fafff35d0e', '2.00', 4, 1, 0, 0, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `articles_articlecategories`
--

CREATE TABLE IF NOT EXISTS `articles_articlecategories` (
  `id` int(10) UNSIGNED NOT NULL,
  `articles_id` int(10) UNSIGNED DEFAULT NULL,
  `articlecategories_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `articles_articlecategories`
--

INSERT INTO `articles_articlecategories` (`id`, `articles_id`, `articlecategories_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 3),
(4, 4, 1),
(5, 5, 1),
(6, 6, 2),
(7, 7, 2),
(8, 8, 1),
(43, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attendenceprofile`
--

CREATE TABLE IF NOT EXISTS `attendenceprofile` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `monday` tinyint(1) DEFAULT NULL,
  `tuesday` tinyint(1) DEFAULT NULL,
  `thursday` tinyint(1) DEFAULT NULL,
  `friday` tinyint(1) DEFAULT NULL,
  `user` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `attendenceprofile`
--

INSERT INTO `attendenceprofile` (`id`, `created_by`, `created_on`, `monday`, `tuesday`, `thursday`, `friday`, `user`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 14:47:45', 1, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attendences`
--

CREATE TABLE IF NOT EXISTS `attendences` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `date` date DEFAULT NULL,
  `user` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `attendences`
--

INSERT INTO `attendences` (`id`, `created_by`, `created_on`, `date`, `user`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:30', '2022-03-08', 1),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:18', '2022-03-15', 1);

-- --------------------------------------------------------

--
-- Table structure for table `attendence_exceptions`
--

CREATE TABLE IF NOT EXISTS `attendence_exceptions` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `user` int(10) UNSIGNED DEFAULT NULL,
  `global` tinyint(1) DEFAULT 1,
  `from` date DEFAULT NULL,
  `till` date DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `campuses`
--

CREATE TABLE IF NOT EXISTS `campuses` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `short_name` varchar(200) DEFAULT NULL,
  `streetname` varchar(200) DEFAULT NULL,
  `house_number` varchar(200) DEFAULT NULL,
  `postal_code` varchar(200) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `campuses`
--

INSERT INTO `campuses` (`id`, `created_by`, `created_on`, `name`, `short_name`, `streetname`, `house_number`, `postal_code`, `city`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:18', 'Hoofd Campus', 'Campus', 'straat', '1', '1234', 'stad');

-- --------------------------------------------------------

--
-- Table structure for table `cardleasings`
--

CREATE TABLE IF NOT EXISTS `cardleasings` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `user` int(10) UNSIGNED DEFAULT NULL,
  `card` int(10) UNSIGNED DEFAULT NULL,
  `from` date DEFAULT NULL,
  `till` date DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  `saldo` decimal(10,2) DEFAULT 0.00,
  `card_leasing_type` int(10) UNSIGNED DEFAULT NULL,
  `full_description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cardleasings`
--

INSERT INTO `cardleasings` (`id`, `created_by`, `created_on`, `description`, `user`, `card`, `from`, `till`, `active`, `saldo`, `card_leasing_type`, `full_description`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:31', 'John Smith Card Leasing', 1, 1, '2022-03-01', '2052-05-16', 1, '89.00', 1, NULL),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:13:31', 'Test beschrijving', 1, 2, '2022-03-15', NULL, 1, '0.00', 1, 'John Smith - DBCB2281 (Test beschrijving)');

-- --------------------------------------------------------

--
-- Table structure for table `cards`
--

CREATE TABLE IF NOT EXISTS `cards` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `code` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cards`
--

INSERT INTO `cards` (`id`, `created_by`, `created_on`, `code`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:19', 'DBCFC441'),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:11:24', 'DBCB2281');

-- --------------------------------------------------------

--
-- Table structure for table `card_leasing_type`
--

CREATE TABLE IF NOT EXISTS `card_leasing_type` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `unlimited_credit` tinyint(1) DEFAULT 1,
  `allowed_credit` decimal(10,2) DEFAULT 0.00,
  `pricelevel` int(10) UNSIGNED DEFAULT NULL,
  `no_attendence_fee` tinyint(1) DEFAULT 1,
  `nr_of_allowed_cards` int(11) DEFAULT 1,
  `send_mail_when_balance_is_low` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `card_leasing_type`
--

INSERT INTO `card_leasing_type` (`id`, `created_by`, `created_on`, `name`, `unlimited_credit`, `allowed_credit`, `pricelevel`, `no_attendence_fee`, `nr_of_allowed_cards`, `send_mail_when_balance_is_low`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Standaard', 0, '200.00', 1, 0, 1, 1),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'Leerkrachtenkaart', 1, '0.00', 4, 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `classgroup`
--

CREATE TABLE IF NOT EXISTS `classgroup` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `code` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `internal_number` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `classgroup`
--

INSERT INTO `classgroup` (`id`, `created_by`, `created_on`, `code`, `name`, `description`, `internal_number`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:19', '4AB5', '4AB5', 'Test klas', 1);

-- --------------------------------------------------------

--
-- Table structure for table `coaccounts`
--

CREATE TABLE IF NOT EXISTS `coaccounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `first_name` varchar(200) DEFAULT NULL,
  `last_name` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coaccounts`
--

INSERT INTO `coaccounts` (`id`, `created_by`, `created_on`, `email`, `first_name`, `last_name`, `password`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:19', 'example@mypacr.be', 'Bob', 'Smith', '$argon2i$v=19$m=4096,t=3,p=1$CWOApD4yqtTMwo0ZhntRbA$UlNJkt8IU+qHmqXOtBEA4Dj59ZQCmn2+TTZKpRWCuZU');

-- --------------------------------------------------------

--
-- Table structure for table `coaccounts_cardleasings`
--

CREATE TABLE IF NOT EXISTS `coaccounts_cardleasings` (
  `id` int(10) UNSIGNED NOT NULL,
  `coaccounts_id` int(10) UNSIGNED DEFAULT NULL,
  `cardleasings_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coaccounts_cardleasings`
--

INSERT INTO `coaccounts_cardleasings` (`id`, `coaccounts_id`, `cardleasings_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `coaccounts_users`
--

CREATE TABLE IF NOT EXISTS `coaccounts_users` (
  `id` int(10) UNSIGNED NOT NULL,
  `coaccounts_id` int(10) UNSIGNED DEFAULT NULL,
  `users_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `coaccounts_users`
--

INSERT INTO `coaccounts_users` (`id`, `coaccounts_id`, `users_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `controleresults`
--

CREATE TABLE IF NOT EXISTS `controleresults` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `controle` int(10) UNSIGNED DEFAULT NULL,
  `event` int(10) UNSIGNED DEFAULT NULL,
  `participant` int(10) UNSIGNED DEFAULT NULL,
  `handled` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `controles`
--

CREATE TABLE IF NOT EXISTS `controles` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `event` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `last_controle_run` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `controle_exceptions`
--

CREATE TABLE IF NOT EXISTS `controle_exceptions` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `from` date DEFAULT NULL,
  `till` date DEFAULT NULL,
  `klas` int(10) UNSIGNED DEFAULT NULL,
  `participant` int(10) UNSIGNED DEFAULT NULL,
  `event` int(10) UNSIGNED DEFAULT NULL,
  `global` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_activity`
--

CREATE TABLE IF NOT EXISTS `directus_activity` (
  `id` int(10) UNSIGNED NOT NULL,
  `action` varchar(45) NOT NULL,
  `user` char(36) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `ip` varchar(50) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `collection` varchar(64) NOT NULL,
  `item` varchar(255) NOT NULL,
  `comment` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `directus_collections`
--
--

CREATE TABLE IF NOT EXISTS`directus_collections` (
  `collection` varchar(64) NOT NULL,
  `icon` varchar(30) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `display_template` varchar(255) DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `singleton` tinyint(1) NOT NULL DEFAULT 0,
  `translations` json CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`translations`) OR json_valid(`translations`) ),
  `archive_field` varchar(64) DEFAULT NULL,
  `archive_app_filter` tinyint(1) NOT NULL DEFAULT 1,
  `archive_value` varchar(255) DEFAULT NULL,
  `unarchive_value` varchar(255) DEFAULT NULL,
  `sort_field` varchar(64) DEFAULT NULL,
  `accountability` varchar(255) DEFAULT 'all',
  `color` varchar(255) DEFAULT NULL,
  `item_duplication_fields` json CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`item_duplication_fields`) OR json_valid(`item_duplication_fields`) != 0),
  `sort` int(11) DEFAULT NULL,
  `group` varchar(64) DEFAULT NULL,
  `collapse` varchar(255) NOT NULL DEFAULT 'open'

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_collections`
--

INSERT INTO `directus_collections` (`collection`, `icon`, `note`, `display_template`, `hidden`, `singleton`, `translations`, `archive_field`, `archive_app_filter`, `archive_value`, `unarchive_value`, `sort_field`, `accountability`, `color`, `item_duplication_fields`, `sort`, `group`, `collapse`) VALUES
('absences', 'event_seat', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('admin_settings', NULL, NULL, NULL, 0, 1, NULL, 'status', 1, 'deleted', 'draft', NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('admin_smartschoolimport', NULL, NULL, NULL, 0, 1, NULL, 'status', 1, 'deleted', 'draft', NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('articlecategories', 'category', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('articles', 'fastfood', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('articles_articlecategories', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('attendenceprofile', 'assignment', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('attendences', 'alarm_on', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('attendence_exceptions', 'bug_report', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('campuses', 'school', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('cardleasings', 'card_membership', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('cards', 'credit_card', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('card_leasing_type', 'merge_type', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('classgroup', 'group_work', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('coaccounts', 'account_circle', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('coaccounts_cardleasings', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('coaccounts_users', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('controleresults', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('controles', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('controle_exceptions', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('eventregistration', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('events', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('eventtype', NULL, NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('globalsettings', 'settings', NULL, NULL, 0, 1, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('online_payment', 'money', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('online_topoff', 'space_bar', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('orderitems', 'add_shopping_cart', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('orders', 'shopping_cart', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('pricelevels', 'list', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('prices', 'euro_symbol', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('reports', 'library_books', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('terminalfunctions', 'settings_input_component', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('terminals', 'computer', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('terminals_terminalfunctions', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('transactions', 'list_alt', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('usergroups', 'supervisor_account', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('users', 'accessibility_new', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('users_campuses', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('users_classgroup', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('users_usergroups', NULL, 'Junction Collection', NULL, 1, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('vat_levels', 'device_hub', NULL, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open'),
('z_configurations', 'settings_applications', NULL, NULL, 0, 0, NULL, 'status', 1, 'deleted', 'draft', NULL, 'all', NULL, NULL, NULL, NULL, 'open');

-- --------------------------------------------------------

--
-- Table structure for table `directus_dashboards`
--

CREATE TABLE IF NOT EXISTS `directus_dashboards` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `icon` varchar(30) NOT NULL DEFAULT 'dashboard',
  `note` text DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_created` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_fields`
--

CREATE TABLE IF NOT EXISTS`directus_fields` (
  `id` int(10) UNSIGNED NOT NULL,
  `collection` varchar(64) NOT NULL,
  `field` varchar(64) NOT NULL,
  `special` varchar(64) DEFAULT NULL,
  `interface` varchar(64) DEFAULT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`options`) OR json_valid(`options`)),
  `display` varchar(64) DEFAULT NULL,
  `display_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`display_options`) OR json_valid(`display_options`)),
  `readonly` tinyint(1) NOT NULL DEFAULT 0,
  `hidden` tinyint(1) NOT NULL DEFAULT 0,
  `sort` int(10) UNSIGNED DEFAULT NULL,
  `width` varchar(30) DEFAULT 'full',
  `translations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`translations`) OR json_valid(`translations`)),
  `note` text DEFAULT NULL,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`conditions`) OR json_valid(`conditions`)),
  `required` tinyint(1) DEFAULT 0,
  `group` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_fields`
--

INSERT INTO `directus_fields` (`id`, `collection`, `field`, `special`, `interface`, `options`, `display`, `display_options`, `readonly`, `hidden`, `sort`, `width`, `translations`, `note`, `conditions`, `required`, `group`) VALUES
(949, 'absences', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(950, 'absences', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(951, 'absences', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(952, 'absences', 'date_of_absence', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(953, 'absences', 'user', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}}  {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(954, 'absences', 'handled', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(955, 'admin_settings', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(956, 'admin_settings', 'status', NULL, 'select-dropdown', '{\"choices\":[{\"text\":\"Published\",\"value\":\"published\"},{\"text\":\"Draft\",\"value\":\"draft\"},{\"text\":\"Deleted\",\"value\":\"deleted\"}]}', NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(957, 'admin_settings', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(958, 'admin_settings', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(959, 'admin_settings', 'allowed_modules', 'json', 'json', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(960, 'admin_smartschoolimport', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(961, 'admin_smartschoolimport', 'status', NULL, 'select-dropdown', '{\"choices\":[{\"text\":\"Published\",\"value\":\"published\"},{\"text\":\"Draft\",\"value\":\"draft\"},{\"text\":\"Deleted\",\"value\":\"deleted\"}]}', NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(962, 'admin_smartschoolimport', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(963, 'admin_smartschoolimport', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(964, 'articlecategories', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(965, 'articlecategories', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(966, 'articlecategories', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(967, 'articlecategories', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(968, 'articles', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(969, 'articles', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(970, 'articles', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(971, 'articles', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(972, 'articles', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(973, 'articles', 'picture', NULL, 'file', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(974, 'articles', 'fallback_price', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(975, 'articles', 'vat_level', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{description}} - {{taxpercentage}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(976, 'articles', 'vat_included_in_price', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(977, 'articles', 'does_not_trigger_attendence', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(978, 'articles', 'no_attendence_fee', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(979, 'articles', 'active', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(980, 'articles', 'order', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(981, 'articles', 'categories', 'm2m', 'list-m2m', '{\"template\":\"{{categories_id.name}}\",\"enableCreate\":true,\"enableSelect\":true}', NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(982, 'articles', 'prices', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(983, 'articles_articlecategories', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(984, 'articles_articlecategories', 'articles_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(985, 'articles_articlecategories', 'articlecategories_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(986, 'attendenceprofile', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(987, 'attendenceprofile', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(988, 'attendenceprofile', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(989, 'attendenceprofile', 'monday', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(990, 'attendenceprofile', 'tuesday', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(991, 'attendenceprofile', 'thursday', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(992, 'attendenceprofile', 'friday', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(993, 'attendenceprofile', 'user', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}} {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(994, 'attendences', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(995, 'attendences', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(996, 'attendences', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(997, 'attendences', 'date', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(998, 'attendences', 'user', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}} {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(999, 'attendence_exceptions', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1000, 'attendence_exceptions', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1001, 'attendence_exceptions', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1002, 'attendence_exceptions', 'user', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}} {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1003, 'attendence_exceptions', 'global', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1004, 'attendence_exceptions', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1005, 'attendence_exceptions', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1006, 'attendence_exceptions', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, 'reden van uitzondering', NULL, 0, NULL),
(1007, 'campuses', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 'full', NULL, '', NULL, 0, NULL),
(1008, 'campuses', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 8, 'full', NULL, '', NULL, 0, NULL),
(1009, 'campuses', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 9, 'full', NULL, '', NULL, 0, NULL),
(1010, 'campuses', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, 2, 'full', NULL, '', NULL, 0, NULL),
(1011, 'campuses', 'short_name', NULL, 'input', NULL, NULL, NULL, 0, 0, 10, 'full', NULL, '', NULL, 0, NULL),
(1012, 'campuses', 'streetname', NULL, 'input', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1013, 'campuses', 'house_number', NULL, 'input', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1014, 'campuses', 'postal_code', NULL, 'input', NULL, NULL, NULL, 0, 0, 6, 'full', NULL, '', NULL, 0, NULL),
(1015, 'campuses', 'city', NULL, 'input', NULL, NULL, NULL, 0, 0, 7, 'full', NULL, '', NULL, 0, NULL),
(1016, 'cardleasings', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1017, 'cardleasings', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1018, 'cardleasings', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1019, 'cardleasings', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1020, 'cardleasings', 'user', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}} {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1021, 'cardleasings', 'card', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{code}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1022, 'cardleasings', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1023, 'cardleasings', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1024, 'cardleasings', 'active', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1025, 'cardleasings', 'saldo', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1026, 'cardleasings', 'card_leasing_type', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1027, 'cardleasings', 'full_description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, 'helpveld om makkelijk te kunnen zoeken. dit veld wordt enkel ingevuld bij het aanmaken en editeren in de code, en wordt nadien niet verder onderhouden. Indien de data dan ook verandert is door manuele acties is dit veld niet meer up to date.', NULL, 0, NULL),
(1028, 'cardleasings', 'transactions', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1029, 'cards', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1030, 'cards', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1031, 'cards', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1032, 'cards', 'code', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1033, 'cards', 'card_leasings', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1034, 'card_leasing_type', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1035, 'card_leasing_type', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1036, 'card_leasing_type', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1037, 'card_leasing_type', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1038, 'card_leasing_type', 'unlimited_credit', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1039, 'card_leasing_type', 'allowed_credit', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1040, 'card_leasing_type', 'pricelevel', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1041, 'card_leasing_type', 'no_attendence_fee', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1042, 'card_leasing_type', 'nr_of_allowed_cards', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, 'Hoeveel kaarten van dit kaartType een gebruiker mag hebben (-1 bij onbeperkt)', NULL, 0, NULL),
(1043, 'card_leasing_type', 'send_mail_when_balance_is_low', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1044, 'classgroup', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 'full', NULL, '', NULL, 0, NULL),
(1045, 'classgroup', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 6, 'full', NULL, '', NULL, 0, NULL),
(1046, 'classgroup', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 7, 'full', NULL, '', NULL, 0, NULL),
(1047, 'classgroup', 'code', NULL, 'input', NULL, NULL, NULL, 0, 0, 3, 'full', NULL, '', NULL, 0, NULL),
(1048, 'classgroup', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1049, 'classgroup', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1050, 'classgroup', 'internal_number', NULL, 'input', NULL, NULL, NULL, 0, 0, 2, 'full', NULL, '', NULL, 0, NULL),
(1051, 'coaccounts', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, NULL, '', NULL, 0, NULL),
(1052, 'coaccounts', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 2, 'full', NULL, '', NULL, 0, NULL),
(1053, 'coaccounts', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 0, 3, 'full', NULL, '', NULL, 0, NULL),
(1054, 'coaccounts', 'email', NULL, 'input', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1055, 'coaccounts', 'first_name', NULL, 'input', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1056, 'coaccounts', 'last_name', NULL, 'input', NULL, NULL, NULL, 0, 0, 6, 'full', NULL, '', NULL, 0, NULL),
(1057, 'coaccounts', 'password', NULL, 'input', NULL, NULL, NULL, 0, 0, 7, 'full', NULL, '', NULL, 0, NULL),
(1058, 'coaccounts', 'allowed_card_leasings', 'm2m', 'list-m2m', '{\"template\":\"{{allowed_card_leasings_id.full_description}}\",\"enableCreate\":true,\"enableSelect\":true}', NULL, NULL, 0, 0, 8, 'full', NULL, NULL, NULL, 0, NULL),
(1059, 'coaccounts', 'users', 'm2m', 'list-m2m', '{\"template\":\"{{users_id.first_name {{last_name}}}}\",\"enableCreate\":true,\"enableSelect\":true}', NULL, NULL, 0, 0, 9, 'full', NULL, NULL, NULL, 0, NULL),
(1060, 'coaccounts_cardleasings', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1061, 'coaccounts_cardleasings', 'coaccounts_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1062, 'coaccounts_cardleasings', 'cardleasings_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1063, 'coaccounts_users', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1064, 'coaccounts_users', 'coaccounts_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1065, 'coaccounts_users', 'users_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1066, 'controleresults', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1067, 'controleresults', 'owner', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1068, 'controleresults', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1069, 'controleresults', 'controle', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{id}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1070, 'controleresults', 'event', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1071, 'controleresults', 'participant', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{firstname}} {{lastname}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1072, 'controleresults', 'handled', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1073, 'controles', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1074, 'controles', 'owner', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1075, 'controles', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1076, 'controles', 'event', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1077, 'controles', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1078, 'controles', 'last_controle_run', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1079, 'controle_exceptions', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1080, 'controle_exceptions', 'owner', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1081, 'controle_exceptions', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1082, 'controle_exceptions', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1083, 'controle_exceptions', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1084, 'controle_exceptions', 'klas', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{code}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1085, 'controle_exceptions', 'participant', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{firstname}} {{lastname}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1086, 'controle_exceptions', 'event', 'm2o', 'select-dropdown-m2o', '{}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1087, 'controle_exceptions', 'global', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1088, 'eventregistration', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1089, 'eventregistration', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1090, 'eventregistration', 'modified_by', 'user-updated', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1091, 'eventregistration', 'modified_on', 'date-updated', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1092, 'eventregistration', 'event', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1093, 'eventregistration', 'participant', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}}{{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1094, 'eventregistration', 'time_of_registration', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1095, 'events', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1096, 'events', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1097, 'events', 'modified_by', 'user-updated', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1098, 'events', 'modified_on', 'date-updated', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1099, 'events', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL);
INSERT INTO `directus_fields` (`id`, `collection`, `field`, `special`, `interface`, `options`, `display`, `display_options`, `readonly`, `hidden`, `sort`, `width`, `translations`, `note`, `conditions`, `required`, `group`) VALUES
(1100, 'events', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1101, 'events', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1102, 'events', 'attendence_profile_based', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1103, 'events', 'feedback2stakeholders', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1104, 'events', 'max_possesion_time', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1105, 'events', 'event_type', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1106, 'events', 'recurring_pattern', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1107, 'events', 'recurring_pattern_duration_in_minutes', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1108, 'eventtype', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1109, 'eventtype', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1110, 'eventtype', 'modified_by', 'user-updated', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1111, 'eventtype', 'modified_on', 'date-updated', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1112, 'eventtype', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1113, 'globalsettings', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1114, 'globalsettings', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1115, 'globalsettings', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1116, 'globalsettings', 'cookie_expiration', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1117, 'globalsettings', 'use_vat', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1118, 'globalsettings', 'entry_fee', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1119, 'globalsettings', 'entry_fee_return_after_buy', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1120, 'globalsettings', 'default_cardleasing_type', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1121, 'globalsettings', 'default_pricelevel', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1122, 'globalsettings', 'handling_cost', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1123, 'globalsettings', 'usergroups_allowed_to_login_into_portal', 'json', 'json', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1124, 'globalsettings', 'low_balance_treshold', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1125, 'globalsettings', 'auth_provider_settings', 'json', 'json', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1126, 'online_payment', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1127, 'online_payment', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1128, 'online_payment', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1129, 'online_payment', 'coaccount', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{first_name}} {{last_name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1130, 'online_payment', 'completed', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1131, 'online_payment', 'handling_fee', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1132, 'online_payment', 'handling_fee_refunded', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1133, 'online_payment', 'time_of_payment', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1134, 'online_payment', 'time_of_payment_with_offset', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1135, 'online_payment', 'time_of_payment_localized', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1136, 'online_payment', 'top_offs', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1137, 'online_topoff', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1138, 'online_topoff', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1139, 'online_topoff', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1140, 'online_topoff', 'card_leasing', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{full_description}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1141, 'online_topoff', 'amount', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1142, 'online_topoff', 'completed', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1143, 'online_topoff', 'online_payment', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{created_on}} {{CoAccount}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1144, 'orderitems', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1145, 'orderitems', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1146, 'orderitems', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1147, 'orderitems', 'article', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1148, 'orderitems', 'amount', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1149, 'orderitems', 'netto_total', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1150, 'orderitems', 'vat_total', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1151, 'orderitems', 'order', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{id}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1152, 'orders', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1153, 'orders', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1154, 'orders', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1155, 'orders', 'returnmode', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1156, 'orders', 'order_items', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1157, 'orders', 'transactions', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1158, 'pricelevels', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1159, 'pricelevels', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1160, 'pricelevels', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1161, 'pricelevels', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1162, 'pricelevels', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1163, 'prices', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1164, 'prices', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1165, 'prices', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1166, 'prices', 'pricelevel', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1167, 'prices', 'amount', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1168, 'prices', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1169, 'prices', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1170, 'prices', 'article_id', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1171, 'prices', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1172, 'reports', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, NULL, NULL, '', NULL, 0, NULL),
(1173, 'reports', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 2, 'full', NULL, '', NULL, 0, NULL),
(1174, 'reports', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 3, 'full', NULL, '', NULL, 0, NULL),
(1175, 'reports', 'query', NULL, 'input-multiline', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1176, 'reports', 'title', NULL, 'input', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1177, 'reports', 'parameterobject', 'json', 'json', NULL, NULL, NULL, 0, 0, 6, 'full', NULL, '', NULL, 0, NULL),
(1178, 'reports', 'key', NULL, 'input', NULL, NULL, NULL, 0, 0, 8, 'full', NULL, '', NULL, 0, NULL),
(1179, 'reports', 'parameterchars', NULL, 'input', NULL, NULL, NULL, 0, 0, 9, 'full', NULL, '', NULL, 0, NULL),
(1180, 'reports', 'fieldsobject', 'json', 'json', NULL, NULL, NULL, 0, 0, 7, 'full', NULL, '', NULL, 0, NULL),
(1181, 'reports', 'landscape', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1182, 'reports', 'pivot_table', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1183, 'reports', 'pivot_info', 'json', 'json', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1184, 'terminalfunctions', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1185, 'terminalfunctions', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1186, 'terminalfunctions', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1187, 'terminalfunctions', 'functionname', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1188, 'terminals', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1189, 'terminals', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1190, 'terminals', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1191, 'terminals', 'code', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1192, 'terminals', 'campus', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1193, 'terminals', 'in_use_untill', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1194, 'terminals', 'cookielink', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1195, 'terminals', 'softpass', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, 'dit wordt gebruikt om bepaalde zaken die aan de terminal gelocked zijn te releasen, zonder dat gewone gebruikers dit kunnen. Hier is geen controle op en blijf ook als gewone tekst staan (omdat het niet bedoeld is als authenticatie) *WORDT MOMENTEEL NOG NIET GEBRUIKT', NULL, 0, NULL),
(1196, 'terminals', 'selectedevent', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1197, 'terminals', 'eventlocked', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1198, 'terminals', 'terminalfunctions', 'm2m', 'list-m2m', '{\"enableCreate\":true,\"enableSelect\":true}', NULL, NULL, 0, 0, NULL, 'full', NULL, NULL, NULL, 0, NULL),
(1199, 'terminals_terminalfunctions', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1200, 'terminals_terminalfunctions', 'terminals_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1201, 'terminals_terminalfunctions', 'terminalfunctions_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, '', NULL, 0, NULL),
(1202, 'transactions', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 'full', NULL, '', NULL, 0, NULL),
(1203, 'transactions', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 2, 'full', NULL, '', NULL, 0, NULL),
(1204, 'transactions', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 3, 'full', NULL, '', NULL, 0, NULL),
(1205, 'transactions', 'amount', NULL, 'input', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1206, 'transactions', 'top_off', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1207, 'transactions', 'terminal', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{code}}\"}', NULL, NULL, 0, 0, 6, 'full', NULL, '', NULL, 0, NULL),
(1208, 'transactions', 'cardleasing', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{full_description}}\"}', NULL, NULL, 0, 0, 7, 'full', NULL, '', NULL, 0, NULL),
(1209, 'transactions', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, 8, 'full', NULL, '', NULL, 0, NULL),
(1210, 'transactions', 'new_saldo', NULL, 'input', NULL, NULL, NULL, 0, 0, 9, 'full', NULL, '', NULL, 0, NULL),
(1211, 'transactions', 'no_vat', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, 10, 'full', NULL, '', NULL, 0, NULL),
(1212, 'transactions', 'time_of_transaction', NULL, 'datetime', NULL, NULL, NULL, 0, 0, 11, 'full', NULL, '', NULL, 0, NULL),
(1213, 'transactions', 'order', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{id}}\"}', NULL, NULL, 0, 0, 14, 'full', NULL, '', NULL, 0, NULL),
(1214, 'transactions', 'time_of_transaction_with_offset', NULL, 'input', NULL, NULL, NULL, 0, 0, 12, 'full', NULL, '', NULL, 0, NULL),
(1215, 'transactions', 'time_of_transaction_localized', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1216, 'usergroups', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 'full', NULL, '', NULL, 0, NULL),
(1217, 'usergroups', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 4, 'full', NULL, '', NULL, 0, NULL),
(1218, 'usergroups', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 5, 'full', NULL, '', NULL, 0, NULL),
(1219, 'usergroups', 'name', NULL, 'input', NULL, NULL, NULL, 0, 0, 2, 'full', NULL, '', NULL, 0, NULL),
(1220, 'usergroups', 'pricelevel', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1221, 'users', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 'full', NULL, '', NULL, 0, NULL),
(1222, 'users', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 14, 'full', NULL, '', NULL, 0, NULL),
(1223, 'users', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 13, 'full', NULL, '', NULL, 0, NULL),
(1224, 'users', 'first_name', NULL, 'input', NULL, NULL, NULL, 0, 0, 4, 'full', NULL, '', NULL, 0, NULL),
(1225, 'users', 'picture', NULL, 'file', NULL, NULL, NULL, 0, 0, 12, 'full', NULL, '', NULL, 0, NULL),
(1226, 'users', 'date_of_birth', NULL, 'datetime', NULL, NULL, NULL, 0, 0, 6, 'full', NULL, '', NULL, 0, NULL),
(1227, 'users', 'internal_number', NULL, 'input', NULL, NULL, NULL, 0, 0, 9, 'full', NULL, '', NULL, 0, NULL),
(1228, 'users', 'last_name', NULL, 'input', NULL, NULL, NULL, 0, 0, 5, 'full', NULL, '', NULL, 0, NULL),
(1229, 'users', 'classgroup', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{code}} - {{name}}\"}', NULL, NULL, 0, 0, 7, 'full', NULL, '', NULL, 0, NULL),
(1230, 'users', 'campus', 'm2o', 'select-dropdown-m2o', '{\"template\":\"{{name}}\"}', NULL, NULL, 0, 0, 8, 'full', NULL, '', NULL, 0, NULL),
(1231, 'users', 'smartschool_username', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1232, 'users', 'selective_card_visibility', 'boolean', 'boolean', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1233, 'users', 'card_leasings', 'o2m', 'list-o2m', NULL, NULL, NULL, 0, 0, 15, 'full', NULL, NULL, NULL, 0, NULL),
(1234, 'users', 'usergroup', 'm2m', 'list-m2m', '{}', NULL, NULL, 0, 0, 10, 'full', NULL, NULL, NULL, 0, NULL),
(1235, 'users_campuses', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1236, 'users_campuses', 'users_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1237, 'users_campuses', 'campuses_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1238, 'users_classgroup', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1239, 'users_classgroup', 'users_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1240, 'users_classgroup', 'classgroup_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1241, 'users_classgroup', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1242, 'users_classgroup', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1243, 'users_usergroups', 'id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1244, 'users_usergroups', 'users_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1245, 'users_usergroups', 'usergroups_id', NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1246, 'users_usergroups', 'from', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1247, 'users_usergroups', 'till', NULL, 'datetime', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1248, 'vat_levels', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1249, 'vat_levels', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1250, 'vat_levels', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1251, 'vat_levels', 'description', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1252, 'vat_levels', 'taxpercentage', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL);
INSERT INTO `directus_fields` (`id`, `collection`, `field`, `special`, `interface`, `options`, `display`, `display_options`, `readonly`, `hidden`, `sort`, `width`, `translations`, `note`, `conditions`, `required`, `group`) VALUES
(1253, 'z_configurations', 'id', NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, '', NULL, 0, NULL),
(1254, 'z_configurations', 'status', NULL, 'select-dropdown', '{\"choices\":[{\"text\":\"Published\",\"value\":\"published\"},{\"text\":\"Draft\",\"value\":\"draft\"},{\"text\":\"Deleted\",\"value\":\"deleted\"}]}', NULL, NULL, 0, 0, 0, 'full', NULL, '', NULL, 0, NULL),
(1255, 'z_configurations', 'created_by', 'user-created', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1256, 'z_configurations', 'created_on', 'date-created', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1257, 'z_configurations', 'modified_by', 'user-updated', 'select-dropdown-m2o', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1258, 'z_configurations', 'modified_on', 'date-updated', 'datetime', NULL, NULL, NULL, 1, 1, 0, 'full', NULL, '', NULL, 0, NULL),
(1259, 'z_configurations', 'key', NULL, 'input', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL),
(1260, 'z_configurations', 'config', 'json', 'json', NULL, NULL, NULL, 0, 0, NULL, 'full', NULL, '', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `directus_files`
--

CREATE TABLE IF NOT EXISTS `directus_files` (
  `id` char(36) NOT NULL,
  `storage` varchar(255) NOT NULL,
  `filename_disk` varchar(255) DEFAULT NULL,
  `filename_download` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `folder` char(36) DEFAULT NULL,
  `uploaded_by` char(36) DEFAULT NULL,
  `uploaded_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `charset` varchar(50) DEFAULT NULL,
  `filesize` bigint(20) DEFAULT NULL,
  `width` int(10) UNSIGNED DEFAULT NULL,
  `height` int(10) UNSIGNED DEFAULT NULL,
  `duration` int(10) UNSIGNED DEFAULT NULL,
  `embed` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`metadata`) OR json_valid(`metadata`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_files`
--

INSERT INTO `directus_files` (`id`, `storage`, `filename_disk`, `filename_download`, `title`, `type`, `folder`, `uploaded_by`, `uploaded_on`, `modified_by`, `modified_on`, `charset`, `filesize`, `width`, `height`, `duration`, `embed`, `description`, `location`, `tags`, `metadata`) VALUES
('470a4da8-78d6-4271-8ecc-a4fafff35d0e', 'local', '470a4da8-78d6-4271-8ecc-a4fafff35d0e.jpg', 'food.jpg', 'Food', 'image/jpeg', NULL, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:36:58', NULL, '2022-03-14 12:36:58', NULL, 33547, 512, 512, NULL, NULL, '', NULL, NULL, NULL),
('4b6b6214-f804-4767-aa4b-a67358643996', 'local', '4b6b6214-f804-4767-aa4b-a67358643996.webp', 'profile-picture.webp', 'Profile Picture', 'image/webp', NULL, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 09:18:52', NULL, '2022-03-14 09:18:52', NULL, 17436, 1280, 1280, NULL, NULL, '', NULL, NULL, '{}');

-- --------------------------------------------------------

--
-- Table structure for table `directus_folders`
--

CREATE TABLE IF NOT EXISTS `directus_folders` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_migrations`
--

CREATE TABLE IF NOT EXISTS`directus_migrations` (
  `version` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_migrations`
--

INSERT INTO `directus_migrations` (`version`, `name`, `timestamp`) VALUES
('20201028A', 'Remove Collection Foreign Keys', '2022-03-11 07:47:49'),
('20201029A', 'Remove System Relations', '2022-03-11 07:47:49'),
('20201029B', 'Remove System Collections', '2022-03-11 07:47:49'),
('20201029C', 'Remove System Fields', '2022-03-11 07:47:49'),
('20201105A', 'Add Cascade System Relations', '2022-03-11 07:47:50'),
('20201105B', 'Change Webhook URL Type', '2022-03-11 07:47:50'),
('20210225A', 'Add Relations Sort Field', '2022-03-11 07:47:50'),
('20210304A', 'Remove Locked Fields', '2022-03-11 07:47:50'),
('20210312A', 'Webhooks Collections Text', '2022-03-11 07:47:50'),
('20210331A', 'Add Refresh Interval', '2022-03-11 07:47:50'),
('20210415A', 'Make Filesize Nullable', '2022-03-11 07:47:50'),
('20210416A', 'Add Collections Accountability', '2022-03-11 07:47:50'),
('20210422A', 'Remove Files Interface', '2022-03-11 07:47:50'),
('20210506A', 'Rename Interfaces', '2022-03-11 07:47:50'),
('20210510A', 'Restructure Relations', '2022-03-11 07:47:50'),
('20210518A', 'Add Foreign Key Constraints', '2022-03-11 07:47:50'),
('20210519A', 'Add System Fk Triggers', '2022-03-11 07:47:50'),
('20210521A', 'Add Collections Icon Color', '2022-03-11 07:47:50'),
('20210525A', 'Add Insights', '2022-03-11 07:47:51'),
('20210608A', 'Add Deep Clone Config', '2022-03-11 07:47:51'),
('20210626A', 'Change Filesize Bigint', '2022-03-11 07:47:51'),
('20210716A', 'Add Conditions to Fields', '2022-03-11 07:47:51'),
('20210721A', 'Add Default Folder', '2022-03-11 07:47:51'),
('20210802A', 'Replace Groups', '2022-03-11 07:47:51'),
('20210803A', 'Add Required to Fields', '2022-03-11 07:47:51'),
('20210805A', 'Update Groups', '2022-03-11 07:47:51'),
('20210805B', 'Change Image Metadata Structure', '2022-03-11 07:47:51'),
('20210811A', 'Add Geometry Config', '2022-03-11 07:47:51'),
('20210831A', 'Remove Limit Column', '2022-03-11 07:47:51'),
('20210903A', 'Add Auth Provider', '2022-03-11 07:47:51'),
('20210907A', 'Webhooks Collections Not Null', '2022-03-11 07:47:51'),
('20210910A', 'Move Module Setup', '2022-03-11 07:47:51'),
('20210920A', 'Webhooks URL Not Null', '2022-03-11 07:47:51'),
('20210924A', 'Add Collection Organization', '2022-03-11 07:47:51'),
('20210927A', 'Replace Fields Group', '2022-03-11 07:47:51'),
('20210927B', 'Replace M2M Interface', '2022-03-11 07:47:51'),
('20210929A', 'Rename Login Action', '2022-03-11 07:47:51'),
('20211007A', 'Update Presets', '2022-03-11 07:47:51'),
('20211009A', 'Add Auth Data', '2022-03-11 07:47:51'),
('20211016A', 'Add Webhook Headers', '2022-03-11 07:47:51'),
('20211103A', 'Set Unique to User Token', '2022-03-11 07:47:51'),
('20211103B', 'Update Special Geometry', '2022-03-11 07:47:51'),
('20211104A', 'Remove Collections Listing', '2022-03-11 07:47:51'),
('20211118A', 'Add Notifications', '2022-03-11 07:47:51'),
('20211211A', 'Add Shares', '2022-03-11 07:47:52'),
('20211230A', 'Add Project Descriptor', '2022-03-11 07:47:52'),
('20220303A', 'Remove Default Project Color', '2022-03-11 07:47:52');

-- --------------------------------------------------------

--
-- Table structure for table `directus_notifications`
--

CREATE TABLE IF NOT EXISTS `directus_notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(255) DEFAULT 'inbox',
  `recipient` char(36) NOT NULL,
  `sender` char(36) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text DEFAULT NULL,
  `collection` varchar(64) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_panels`
--

CREATE TABLE IF NOT EXISTS `directus_panels` (
  `id` char(36) NOT NULL,
  `dashboard` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `icon` varchar(30) DEFAULT 'insert_chart',
  `color` varchar(10) DEFAULT NULL,
  `show_header` tinyint(1) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `position_x` int(11) NOT NULL,
  `position_y` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`options`) OR json_valid(`options`)),
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_created` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_permissions`
--

CREATE TABLE IF NOT EXISTS `directus_permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `role` char(36) DEFAULT NULL,
  `collection` varchar(64) NOT NULL,
  `action` varchar(10) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`permissions`) OR json_valid(`permissions`)),
  `validation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`validation`) OR json_valid(`validation`)),
  `presets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`presets`) OR json_valid(`presets`)),
  `fields` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_permissions`
--

INSERT INTO `directus_permissions` (`id`, `role`, `collection`, `action`, `permissions`, `validation`, `presets`, `fields`) VALUES
(2, NULL, 'directus_files', 'read', '{\"_and\":[{\"filename_disk\":{\"_contains\":\".webp\"}},{\"filename_disk\":{\"_contains\":\".jpg\"}}]}', '{}', NULL, '*');

-- --------------------------------------------------------

--
-- Table structure for table `directus_presets`
--

CREATE TABLE IF NOT EXISTS `directus_presets` (
  `id` int(10) UNSIGNED NOT NULL,
  `bookmark` varchar(255) DEFAULT NULL,
  `user` char(36) DEFAULT NULL,
  `role` char(36) DEFAULT NULL,
  `collection` varchar(64) DEFAULT NULL,
  `search` varchar(100) DEFAULT NULL,
  `layout` varchar(100) DEFAULT 'tabular',
  `layout_query` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`layout_query`) OR json_valid(`layout_query`)),
  `layout_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`layout_options`) OR json_valid(`layout_options`)),
  `refresh_interval` int(11) DEFAULT NULL,
  `filter` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`filter`) OR json_valid(`filter`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_presets`
--

INSERT INTO `directus_presets` (`id`, `bookmark`, `user`, `role`, `collection`, `search`, `layout`, `layout_query`, `layout_options`, `refresh_interval`, `filter`) VALUES
(1, NULL, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', NULL, 'directus_users', NULL, 'cards', '{\"cards\":{\"sort\":[\"email\"],\"page\":1}}', '{\"cards\":{\"icon\":\"account_circle\",\"title\":\"{{ first_name }} {{ last_name }}\",\"subtitle\":\"{{ email }}\",\"size\":4}}', NULL, NULL),
(2, NULL, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', NULL, 'articles', NULL, 'tabular', NULL, NULL, NULL, NULL),
(3, NULL, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', NULL, 'directus_files', NULL, 'cards', '{\"cards\":{\"sort\":[\"-uploaded_on\"],\"page\":1}}', '{\"cards\":{\"icon\":\"insert_drive_file\",\"title\":\"{{ title }}\",\"subtitle\":\"{{ type }} • {{ filesize }}\",\"size\":4,\"imageFit\":\"crop\"}}', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `directus_relations`
--

CREATE TABLE IF NOT EXISTS `directus_relations` (
  `id` int(10) UNSIGNED NOT NULL,
  `many_collection` varchar(64) NOT NULL,
  `many_field` varchar(64) NOT NULL,
  `one_collection` varchar(64) DEFAULT NULL,
  `one_field` varchar(64) DEFAULT NULL,
  `one_collection_field` varchar(64) DEFAULT NULL,
  `one_allowed_collections` text DEFAULT NULL,
  `junction_field` varchar(64) DEFAULT NULL,
  `sort_field` varchar(64) DEFAULT NULL,
  `one_deselect_action` varchar(255) NOT NULL DEFAULT 'nullify'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_relations`
--

INSERT INTO `directus_relations` (`id`, `many_collection`, `many_field`, `one_collection`, `one_field`, `one_collection_field`, `one_allowed_collections`, `junction_field`, `sort_field`, `one_deselect_action`) VALUES
(57, 'users_usergroups', 'users_id', 'users', 'usergroup', NULL, NULL, 'usergroups_id', NULL, 'nullify'),
(58, 'users_usergroups', 'usergroups_id', 'usergroups', 'users', NULL, NULL, 'users_id', NULL, 'nullify'),
(59, 'terminals', 'campus', 'campuses', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(60, 'attendences', 'user', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(61, 'articles_articlecategories', 'articles_id', 'articles', 'categories', NULL, NULL, 'articlecategories_id', NULL, 'nullify'),
(62, 'articles_articlecategories', 'articlecategories_id', 'articlecategories', 'articles', NULL, NULL, 'articles_id', NULL, 'nullify'),
(63, 'prices', 'pricelevel', 'pricelevels', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(64, 'orderitems', 'article', 'articles', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(65, 'articles', 'vat_level', 'vat_levels', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(66, 'prices', 'article_id', 'articles', 'prices', NULL, NULL, NULL, NULL, 'nullify'),
(67, 'transactions', 'terminal', 'terminals', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(68, 'usergroups', 'pricelevel', 'pricelevels', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(69, 'cardleasings', 'card', 'cards', 'card_leasings', NULL, NULL, NULL, NULL, 'nullify'),
(70, 'cardleasings', 'user', 'users', 'card_leasings', NULL, NULL, NULL, NULL, 'nullify'),
(71, 'users', 'classgroup', 'classgroup', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(72, 'users', 'campus', 'campuses', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(73, 'terminals_terminalfunctions', 'terminals_id', 'terminals', 'terminalfunctions', NULL, NULL, 'terminalfunctions_id', NULL, 'nullify'),
(74, 'terminals_terminalfunctions', 'terminalfunctions_id', 'terminalfunctions', 'terminals', NULL, NULL, 'terminals_id', NULL, 'nullify'),
(75, 'transactions', 'cardleasing', 'cardleasings', 'transactions', NULL, NULL, NULL, NULL, 'nullify'),
(76, 'coaccounts_users', 'users_id', 'users', 'coaccounts', NULL, NULL, 'coaccounts_id', NULL, 'nullify'),
(77, 'coaccounts_users', 'coaccounts_id', 'coaccounts', 'users', NULL, NULL, 'users_id', NULL, 'nullify'),
(78, 'card_leasing_type', 'pricelevel', 'pricelevels', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(79, 'cardleasings', 'card_leasing_type', 'card_leasing_type', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(80, 'globalsettings', 'default_cardleasing_type', 'card_leasing_type', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(81, 'globalsettings', 'default_pricelevel', 'pricelevels', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(82, 'online_payment', 'coaccount', 'coaccounts', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(83, 'orderitems', 'order', 'orders', 'order_items', NULL, NULL, NULL, NULL, 'nullify'),
(84, 'online_topoff', 'card_leasing', 'cardleasings', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(85, 'online_topoff', 'online_payment', 'online_payment', 'top_offs', NULL, NULL, NULL, NULL, 'nullify'),
(86, 'attendenceprofile', 'user', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(87, 'transactions', 'order', 'orders', 'transactions', NULL, NULL, NULL, NULL, 'nullify'),
(88, 'coaccounts_cardleasings', 'coaccounts_id', 'coaccounts', 'allowed_card_leasings', NULL, NULL, 'cardleasings_id', NULL, 'nullify'),
(89, 'coaccounts_cardleasings', 'cardleasings_id', 'cardleasings', 'coaccounts', NULL, NULL, 'coaccounts_id', NULL, 'nullify'),
(90, 'absences', 'user', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(91, 'attendence_exceptions', 'user', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(92, 'events', 'event_type', 'eventtype', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(93, 'eventregistration', 'event', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(94, 'eventregistration', 'participant', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(95, 'terminals', 'selectedevent', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(96, 'controles', 'event', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(97, 'controleresults', 'controle', 'controles', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(98, 'controleresults', 'event', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(99, 'controleresults', 'participant', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(100, 'controle_exceptions', 'klas', 'classgroup', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(101, 'controle_exceptions', 'participant', 'users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(102, 'controle_exceptions', 'event', 'events', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(103, 'articles', 'picture', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(104, 'eventregistration', 'modified_by', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(105, 'events', 'modified_by', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(106, 'eventtype', 'modified_by', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(107, 'users', 'picture', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify'),
(108, 'z_configurations', 'modified_by', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

-- --------------------------------------------------------

--
-- Table structure for table `directus_revisions`
--

CREATE TABLE IF NOT EXISTS `directus_revisions` (
  `id` int(10) UNSIGNED NOT NULL,
  `activity` int(10) UNSIGNED NOT NULL,
  `collection` varchar(64) NOT NULL,
  `item` varchar(255) NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`data`) OR json_valid(`data`)),
  `delta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`delta`) OR json_valid(`delta`)),
  `parent` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `directus_roles`
--

CREATE TABLE IF NOT EXISTS `directus_roles` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `icon` varchar(30) NOT NULL DEFAULT 'supervised_user_circle',
  `description` text DEFAULT NULL,
  `ip_access` text DEFAULT NULL,
  `enforce_tfa` tinyint(1) NOT NULL DEFAULT 0,
  `admin_access` tinyint(1) NOT NULL DEFAULT 0,
  `app_access` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_roles`
--

INSERT INTO `directus_roles` (`id`, `name`, `icon`, `description`, `ip_access`, `enforce_tfa`, `admin_access`, `app_access`) VALUES
('709d49f9-9640-4873-bb19-90ef18d2ef25', 'Administrator', 'verified', '$t:admin_description', NULL, 0, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `directus_sessions`
--

CREATE TABLE IF NOT EXISTS `directus_sessions` (
  `token` varchar(64) NOT NULL,
  `user` char(36) DEFAULT NULL,
  `expires` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ip` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `share` char(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


--
-- Table structure for table `directus_settings`
--

CREATE TABLE IF NOT EXISTS `directus_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `project_name` varchar(100) NOT NULL DEFAULT 'Directus',
  `project_url` varchar(255) DEFAULT NULL,
  `project_color` varchar(50) DEFAULT NULL,
  `project_logo` char(36) DEFAULT NULL,
  `public_foreground` char(36) DEFAULT NULL,
  `public_background` char(36) DEFAULT NULL,
  `public_note` text DEFAULT NULL,
  `auth_login_attempts` int(10) UNSIGNED DEFAULT 25,
  `auth_password_policy` varchar(100) DEFAULT NULL,
  `storage_asset_transform` varchar(7) DEFAULT 'all',
  `storage_asset_presets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`storage_asset_presets`) OR json_valid(`storage_asset_presets`)),
  `custom_css` text DEFAULT NULL,
  `storage_default_folder` char(36) DEFAULT NULL,
  `basemaps` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`basemaps`) OR json_valid(`basemaps`)),
  `mapbox_key` varchar(255) DEFAULT NULL,
  `module_bar` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`module_bar`) OR json_valid(`module_bar`)),
  `project_descriptor` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_settings`
--

INSERT INTO `directus_settings` (`id`, `project_name`, `project_url`, `project_color`, `project_logo`, `public_foreground`, `public_background`, `public_note`, `auth_login_attempts`, `auth_password_policy`, `storage_asset_transform`, `storage_asset_presets`, `custom_css`, `storage_default_folder`, `basemaps`, `mapbox_key`, `module_bar`, `project_descriptor`) VALUES
(1, 'Directus', NULL, '#AD37EC', NULL, NULL, NULL, NULL, 25, NULL, 'all', NULL, NULL, NULL, NULL, NULL, '[{\"type\":\"module\",\"id\":\"content\",\"enabled\":true},{\"type\":\"module\",\"id\":\"users\",\"enabled\":true},{\"type\":\"module\",\"id\":\"files\",\"enabled\":true},{\"type\":\"module\",\"id\":\"insights\",\"enabled\":true},{\"type\":\"module\",\"id\":\"docs\",\"enabled\":true},{\"type\":\"module\",\"id\":\"settings\",\"enabled\":true,\"locked\":true},{\"type\":\"module\",\"id\":\"test\",\"enabled\":false},{\"type\":\"module\",\"id\":\"rapportage\",\"enabled\":false}]', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `directus_shares`
--

CREATE TABLE IF NOT EXISTS `directus_shares` (
  `id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `collection` varchar(64) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL,
  `role` char(36) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `user_created` char(36) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_start` timestamp NULL DEFAULT NULL,
  `date_end` timestamp NULL DEFAULT NULL,
  `times_used` int(11) DEFAULT 0,
  `max_uses` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `directus_users`
--

CREATE TABLE IF NOT EXISTS `directus_users` (
  `id` char(36) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`tags`) OR json_valid(`tags`)),
  `avatar` char(36) DEFAULT NULL,
  `language` varchar(8) DEFAULT 'en-US',
  `theme` varchar(20) DEFAULT 'auto',
  `tfa_secret` varchar(255) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'active',
  `role` char(36) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `last_access` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_page` varchar(255) DEFAULT NULL,
  `provider` varchar(128) NOT NULL DEFAULT 'default',
  `external_identifier` varchar(255) DEFAULT NULL,
  `auth_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`auth_data`) OR json_valid(`auth_data`)),
  `email_notifications` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `directus_users`
--

INSERT INTO `directus_users` (`id`, `first_name`, `last_name`, `email`, `password`, `location`, `title`, `description`, `tags`, `avatar`, `language`, `theme`, `tfa_secret`, `status`, `role`, `token`, `last_access`, `last_page`, `provider`, `external_identifier`, `auth_data`, `email_notifications`) VALUES
('f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', 'Admin', 'User', 'admin@example.com', '$argon2i$v=19$m=4096,t=3,p=1$Rh0AI248Q5V3Jac9DsvfzQ$CnJ2NX+qnla8YS1eMrOLS7tiIoiS+upyqh0cTcsQJUY', NULL, NULL, NULL, NULL, '4b6b6214-f804-4767-aa4b-a67358643996', 'en-US', 'auto', NULL, 'active', '709d49f9-9640-4873-bb19-90ef18d2ef25', 'wdnwiaodnawkjbdwdban', '2022-03-22 13:33:10', '/content/absences', 'default', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `directus_webhooks`
--

CREATE TABLE IF NOT EXISTS `directus_webhooks` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `method` varchar(10) NOT NULL DEFAULT 'POST',
  `url` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'active',
  `data` tinyint(1) NOT NULL DEFAULT 1,
  `actions` varchar(100) NOT NULL,
  `collections` varchar(255) NOT NULL,
  `headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (ISNULL(`headers`) OR json_valid(`headers`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `eventregistration`
--

CREATE TABLE IF NOT EXISTS `eventregistration` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NULL DEFAULT NULL,
  `event` int(10) UNSIGNED DEFAULT NULL,
  `participant` int(10) UNSIGNED DEFAULT NULL,
  `time_of_registration` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `eventregistration`
--

INSERT INTO `eventregistration` (`id`, `created_on`, `modified_by`, `modified_on`, `event`, `participant`, `time_of_registration`) VALUES
(1, '2022-03-14 12:41:31', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-08-24 18:45:22', 1, 1, '2020-08-24 20:42:16');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `from` datetime DEFAULT NULL,
  `till` datetime DEFAULT NULL,
  `attendence_profile_based` tinyint(1) NOT NULL DEFAULT 1,
  `feedback2stakeholders` tinyint(1) NOT NULL DEFAULT 1,
  `max_possesion_time` varchar(200) DEFAULT NULL,
  `event_type` int(10) UNSIGNED DEFAULT NULL,
  `recurring_pattern` varchar(200) DEFAULT NULL,
  `recurring_pattern_duration_in_minutes` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `created_on`, `modified_by`, `modified_on`, `name`, `from`, `till`, `attendence_profile_based`, `feedback2stakeholders`, `max_possesion_time`, `event_type`, `recurring_pattern`, `recurring_pattern_duration_in_minutes`) VALUES
(1, '2022-03-14 12:37:22', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-08-24 18:29:42', 'TestEvent', '2020-08-24 15:00:00', '2020-08-24 22:00:00', 0, 0, NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `eventtype`
--

CREATE TABLE IF NOT EXISTS `eventtype` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `eventtype`
--

INSERT INTO `eventtype` (`id`, `created_on`, `modified_by`, `modified_on`, `name`) VALUES
(1, '2022-03-14 12:37:19', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-05-28 12:56:26', 'Tijdsgebonden'),
(2, '2022-03-14 12:37:19', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-05-28 12:56:39', 'Voorwerpsgebonden');

-- --------------------------------------------------------

--
-- Table structure for table `globalsettings`
--

CREATE TABLE IF NOT EXISTS `globalsettings` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `cookie_expiration` date DEFAULT NULL,
  `use_vat` tinyint(1) DEFAULT 1,
  `entry_fee` decimal(10,2) DEFAULT 0.00,
  `entry_fee_return_after_buy` tinyint(1) DEFAULT 1,
  `default_cardleasing_type` int(10) UNSIGNED DEFAULT NULL,
  `default_pricelevel` int(10) UNSIGNED DEFAULT NULL,
  `handling_cost` decimal(10,2) DEFAULT NULL,
  `usergroups_allowed_to_login_into_portal` text DEFAULT NULL,
  `low_balance_treshold` decimal(10,2) DEFAULT 0.00,
  `auth_provider_settings` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `globalsettings`
--

INSERT INTO `globalsettings` (`id`, `created_by`, `created_on`, `cookie_expiration`, `use_vat`, `entry_fee`, `entry_fee_return_after_buy`, `default_cardleasing_type`, `default_pricelevel`, `handling_cost`, `usergroups_allowed_to_login_into_portal`, `low_balance_treshold`, `auth_provider_settings`) VALUES
(1, '1', '2019-08-25 15:13:27', '2023-07-31', 0, '0.50', 0, 1, 1, '0.20', '[\"Leerkrachten\"]', '-10.00', '{\"smartschool\":{\"enabled\":false},\"own\":{\"enabled\":true}}');

-- --------------------------------------------------------

--
-- Table structure for table `online_payment`
--

CREATE TABLE IF NOT EXISTS `online_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `coaccount` int(10) UNSIGNED DEFAULT NULL,
  `completed` tinyint(1) DEFAULT 1,
  `handling_fee` decimal(10,2) DEFAULT NULL,
  `handling_fee_refunded` tinyint(1) DEFAULT 1,
  `time_of_payment` datetime DEFAULT NULL,
  `time_of_payment_with_offset` varchar(200) DEFAULT NULL,
  `time_of_payment_localized` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `online_payment`
--

INSERT INTO `online_payment` (`id`, `created_by`, `created_on`, `coaccount`, `completed`, `handling_fee`, `handling_fee_refunded`, `time_of_payment`, `time_of_payment_with_offset`, `time_of_payment_localized`) VALUES
(14, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:22', 1, 0, '0.20', 0, '2022-03-08 12:53:06', '2022-03-08T13:53:06+01:00', '2022-03-08 13:53:06'),
(15, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:22', 1, 0, '0.20', 0, '2022-03-08 13:02:22', '2022-03-08T14:02:22+01:00', '2022-03-08 14:02:22'),
(16, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 15:10:02', 1, 1, '0.20', 1, '2022-03-15 17:09:00', NULL, '2022-03-15 17:09:00'),
(17, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 15:13:48', 1, 0, '0.20', 1, '2022-03-15 17:13:48', '2022-03-15T16:13:48+01:00', '2022-03-15 17:13:48'),
(18, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:36:23', 1, 0, '0.20', 1, '2022-03-16 09:36:23', '2022-03-16T08:36:23+01:00', '2022-03-16 09:36:23'),
(19, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:37:55', 1, 0, '0.20', 1, '2022-03-16 09:37:55', '2022-03-16T08:37:55+01:00', '2022-03-16 09:37:55'),
(20, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:40:37', 1, 0, '0.20', 1, '2022-03-16 09:40:37', '2022-03-16T08:40:37+01:00', '2022-03-16 09:40:37'),
(21, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:43:26', 1, 0, '0.20', 1, '2022-03-16 09:43:26', '2022-03-16T08:43:26+01:00', '2022-03-16 09:43:26'),
(22, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-23 07:51:07', 1, 0, '0.20', 1, '2022-03-23 09:51:07', '2022-03-23T08:51:07+01:00', '2022-03-23 08:51:07'),
(23, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-23 07:53:07', 1, 0, '0.20', 1, '2022-03-23 09:53:07', '2022-03-23T08:53:07+01:00', '2022-03-23 08:53:07');

-- --------------------------------------------------------

--
-- Table structure for table `online_topoff`
--

CREATE TABLE IF NOT EXISTS `online_topoff` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `card_leasing` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT 1,
  `online_payment` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `online_topoff`
--

INSERT INTO `online_topoff` (`id`, `created_by`, `created_on`, `card_leasing`, `amount`, `completed`, `online_payment`) VALUES
(16, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:32', 1, '-1.00', 0, 14),
(17, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:32', 1, '10.00', 0, 15),
(18, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 15:13:48', 1, '5.00', 0, 17),
(19, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:36:23', 1, '5.00', 0, 18),
(20, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:37:55', 1, '10.00', 0, 19),
(21, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:40:37', 1, '10.00', 0, 20),
(22, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-16 07:43:26', 1, '10.00', 0, 21),
(23, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-23 07:51:07', 1, '15.00', 0, 22),
(24, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-23 07:53:07', 1, '15.00', 0, 23);

-- --------------------------------------------------------

--
-- Table structure for table `orderitems`
--

CREATE TABLE IF NOT EXISTS `orderitems` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `article` int(10) UNSIGNED DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `netto_total` decimal(10,2) DEFAULT NULL,
  `vat_total` decimal(10,2) DEFAULT NULL,
  `order` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orderitems`
--

INSERT INTO `orderitems` (`id`, `created_by`, `created_on`, `article`, `amount`, `netto_total`, `vat_total`, `order`) VALUES
(33, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:23', 8, 1, '1.00', '0.00', 19),
(34, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:17', 2, 1, '6.00', '0.00', 20),
(35, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:17', 5, 1, '1.00', '0.00', 20),
(36, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:17', 8, 1, '2.00', '0.00', 20);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `returnmode` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `created_by`, `created_on`, `returnmode`) VALUES
(19, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:19', 0),
(20, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:17', 0);

-- --------------------------------------------------------

--
-- Table structure for table `pricelevels`
--

CREATE TABLE IF NOT EXISTS `pricelevels` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pricelevels`
--

INSERT INTO `pricelevels` (`id`, `created_by`, `created_on`, `name`, `description`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'Standaard tarief', 'Standaard tarief'),
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'Leerkrachten Tarief', 'Tarief voor leerkrachten');

-- --------------------------------------------------------

--
-- Table structure for table `prices`
--

CREATE TABLE IF NOT EXISTS `prices` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `pricelevel` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `from` date DEFAULT NULL,
  `till` date DEFAULT NULL,
  `article_id` int(10) UNSIGNED DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `prices`
--

INSERT INTO `prices` (`id`, `created_by`, `created_on`, `pricelevel`, `amount`, `from`, `till`, `article_id`, `description`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '4.50', '2020-01-01', NULL, 1, NULL),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '4.00', '2020-01-01', NULL, 1, NULL),
(3, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '6.00', '2020-01-01', NULL, 2, NULL),
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '5.00', '2020-01-01', NULL, 2, NULL),
(5, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '2.80', '2020-01-01', NULL, 3, NULL),
(6, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '2.50', '2020-01-01', NULL, 3, NULL),
(7, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '1.00', '2020-01-01', NULL, 4, NULL),
(8, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '0.80', '2020-01-01', NULL, 4, NULL),
(9, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '1.00', '2020-01-01', NULL, 5, NULL),
(10, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '0.80', '2020-01-01', NULL, 5, NULL),
(11, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '1.00', '2020-01-01', NULL, 6, NULL),
(12, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 4, '0.80', '2020-01-01', NULL, 6, NULL),
(13, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:43:22', 1, '2.10', '2020-10-25', NULL, 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `query` text DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `parameterobject` text DEFAULT NULL,
  `key` varchar(200) DEFAULT NULL,
  `parameterchars` varchar(200) DEFAULT NULL,
  `fieldsobject` text DEFAULT NULL,
  `landscape` tinyint(1) DEFAULT 1,
  `pivot_table` tinyint(1) DEFAULT 1,
  `pivot_info` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `created_by`, `created_on`, `query`, `title`, `parameterobject`, `key`, `parameterchars`, `fieldsobject`, `landscape`, `pivot_table`, `pivot_info`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'SELECT \ndate_format(time_of_transaction,\'%d-%m-%Y %h:%i:%s\') as Tijdstip,\namount as Bedrag,\nif(top_off, \'Ja\', \'Nee\') as Teruggave,\ntransactions.description as Omschrijving,\nCONCAT(users.first_name, \' \',users.last_name) as Gebruiker,\ncards.code as Kaart,\nterminals.code as Terminal_Omschrijving\nFROM `transactions`, `cardleasings`, `users`, `cards`, `terminals`\nWHERE transactions.cardleasing = cardleasings.id AND cardleasings.user = users.id AND cardleasings.card = cards.id AND `terminals`.`id` = `transactions`.`terminal`\nAND `time_of_transaction` BETWEEN \'$#Van$#\' and \'$#Tot$#\' \nAND `users`.`id` = $#User$#', 'Transacties per User', '[{\"name\":\"Van\",\"type\":\"DATE\",\"value\":\"\",\"isCollectionItem\":false},{\"name\":\"Tot\",\"type\":\"DATE\",\"value\":\"\",\"isCollectionItem\":false},{\"name\":\"User\",\"type\":\"STRING\",\"value\":\"\",\"isCollectionItem\":true,\"collectionName\":\"users\",\"showInputAs\":\"SEARCHBOX\",\"showProps\":[\"first_name\",\"last_name\"]}]', 'TransactiesPerUser', '$#', NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `terminalfunctions`
--

CREATE TABLE IF NOT EXISTS `terminalfunctions` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `functionname` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `terminalfunctions`
--

INSERT INTO `terminalfunctions` (`id`, `created_by`, `created_on`, `functionname`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'Kassa'),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'AanwezighedenRegistratie'),
(3, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'KaartKoppeling'),
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'RegistratieSysteem');

-- --------------------------------------------------------

--
-- Table structure for table `terminals`
--

CREATE TABLE IF NOT EXISTS `terminals` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `campus` int(10) UNSIGNED DEFAULT NULL,
  `in_use_untill` date DEFAULT NULL,
  `cookielink` varchar(200) DEFAULT NULL,
  `softpass` varchar(200) NOT NULL DEFAULT '0123456789',
  `selectedevent` int(10) UNSIGNED DEFAULT NULL,
  `eventlocked` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `terminals`
--

INSERT INTO `terminals` (`id`, `created_by`, `created_on`, `code`, `campus`, `in_use_untill`, `cookielink`, `softpass`, `selectedevent`, `eventlocked`) VALUES
(18, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:23', 'hoofdTerminal', 1, '2021-01-01', 'b92028e0-a9da-11ec-b22c-b13907e63716', '0123456789', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `terminals_terminalfunctions`
--

CREATE TABLE IF NOT EXISTS `terminals_terminalfunctions` (
  `id` int(10) UNSIGNED NOT NULL,
  `terminals_id` int(10) UNSIGNED DEFAULT NULL,
  `terminalfunctions_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `terminals_terminalfunctions`
--

INSERT INTO `terminals_terminalfunctions` (`id`, `terminals_id`, `terminalfunctions_id`) VALUES
(60, 18, 1),
(61, 18, 2),
(62, 18, 3),
(63, 18, 4);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `top_off` tinyint(1) DEFAULT NULL,
  `terminal` int(10) UNSIGNED DEFAULT NULL,
  `cardleasing` int(10) UNSIGNED DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `new_saldo` decimal(10,2) DEFAULT NULL,
  `no_vat` tinyint(1) DEFAULT 1,
  `time_of_transaction` datetime DEFAULT NULL,
  `order` int(10) UNSIGNED DEFAULT NULL,
  `time_of_transaction_with_offset` varchar(200) DEFAULT NULL,
  `time_of_transaction_localized` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `created_by`, `created_on`, `amount`, `top_off`, `terminal`, `cardleasing`, `description`, `new_saldo`, `no_vat`, `time_of_transaction`, `order`, `time_of_transaction_with_offset`, `time_of_transaction_localized`) VALUES
(44, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:33', '1.00', 0, 18, 1, 'bestelling kassa', '99.00', 1, '2022-03-08 12:42:14', 19, '2022-03-08T13:42:14+01:00', '2022-03-08 1:42:14 PM'),
(45, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:41:33', '0.50', 0, 18, 1, 'stoeltjesgeld', '98.50', 1, '2022-03-08 12:42:15', NULL, '2022-03-08T13:42:15+01:00', '2022-03-08 1:42:15 PM'),
(46, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:18', '9.00', 0, 18, 1, 'bestelling kassa', '89.50', 1, '2022-03-15 12:08:17', 20, '2022-03-15T11:08:17+01:00', '2022-03-15 11:08:17 AM'),
(47, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-15 10:08:34', '0.50', 0, 18, 1, 'stoeltjesgeld', '89.00', 1, '2022-03-15 12:08:34', NULL, '2022-03-15T11:08:34+01:00', '2022-03-15 11:08:34 AM');

-- --------------------------------------------------------

--
-- Table structure for table `usergroups`
--

CREATE TABLE IF NOT EXISTS `usergroups` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `pricelevel` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `usergroups`
--

INSERT INTO `usergroups` (`id`, `created_by`, `created_on`, `name`, `pricelevel`) VALUES
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:24', 'Studenten', 1),
(5, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:24', 'Leerkrachten', 4),
(6, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:24', 'Ouders', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `first_name` varchar(200) DEFAULT NULL,
  `picture` char(36) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `internal_number` varchar(200) DEFAULT NULL,
  `last_name` varchar(200) DEFAULT NULL,
  `classgroup` int(10) UNSIGNED DEFAULT NULL,
  `campus` int(10) UNSIGNED DEFAULT NULL,
  `smartschool_username` varchar(200) DEFAULT NULL,
  `selective_card_visibility` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `created_by`, `created_on`, `first_name`, `picture`, `date_of_birth`, `internal_number`, `last_name`, `classgroup`, `campus`, `smartschool_username`, `selective_card_visibility`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:24', 'John', NULL, '2006-01-01', '501', 'Smith', 1, 1, 'smith.john', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_campuses`
--

CREATE TABLE IF NOT EXISTS `users_campuses` (
  `id` int(10) UNSIGNED NOT NULL,
  `users_id` int(11) DEFAULT NULL,
  `campuses_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users_classgroup`
--

CREATE TABLE IF NOT EXISTS `users_classgroup` (
  `id` int(10) UNSIGNED NOT NULL,
  `users_id` int(11) DEFAULT NULL,
  `classgroup_id` int(11) DEFAULT NULL,
  `from` datetime DEFAULT NULL,
  `till` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `users_usergroups`
--

CREATE TABLE IF NOT EXISTS `users_usergroups` (
  `id` int(10) UNSIGNED NOT NULL,
  `users_id` int(10) UNSIGNED DEFAULT NULL,
  `usergroups_id` int(10) UNSIGNED DEFAULT NULL,
  `from` datetime DEFAULT NULL,
  `till` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users_usergroups`
--

INSERT INTO `users_usergroups` (`id`, `users_id`, `usergroups_id`, `from`, `till`) VALUES
(1, 1, 4, '1970-01-01 01:00:00', '1970-01-01 01:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `vat_levels`
--

CREATE TABLE IF NOT EXISTS `vat_levels` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `description` text DEFAULT NULL,
  `taxpercentage` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vat_levels`
--

INSERT INTO `vat_levels` (`id`, `created_by`, `created_on`, `description`, `taxpercentage`) VALUES
(1, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'Geen BTW', 0),
(2, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', '6 percent', 6),
(3, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', '21 percent btw', 21),
(4, 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'Vrijgesteld', 0);

-- --------------------------------------------------------

--
-- Table structure for table `z_configurations`
--

CREATE TABLE IF NOT EXISTS `z_configurations` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` varchar(20) DEFAULT 'draft',
  `created_by` char(36) DEFAULT NULL,
  `created_on` timestamp NULL DEFAULT NULL,
  `modified_by` char(36) DEFAULT NULL,
  `modified_on` timestamp NULL DEFAULT NULL,
  `key` varchar(200) DEFAULT NULL,
  `config` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `z_configurations`
--

INSERT INTO `z_configurations` (`id`, `status`, `created_by`, `created_on`, `modified_by`, `modified_on`, `key`, `config`) VALUES
(1, 'published', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:20', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-08 10:41:23', 'smartschool', '{\"baseUrl\":\"https://schoonaam.smartschool.be\",\"webserviceUrlPart\":\"/Webservices/V3?wsdl\",\"apiUrlPart\":\"/Api/V1\",\"accesscode\":\"a1a2a3a4a5a6a7a8\"}'),
(2, 'published', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-01-15 04:54:10', 'cronJobs', '{\"cronJobsEnabled\":false}'),
(3, 'published', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2022-03-14 12:37:21', 'f18dbe4d-ab6e-4baf-b213-b03e35ec0ae9', '2020-01-24 01:57:14', 'messageProviderSettings', '[{\"message\":\"lowBalanceWarning\",\"provider\":\"mail\"},{\"message\":\"noAttendenceWarning\",\"provider\":\"mail\"}]');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absences`
--
ALTER TABLE `absences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `absences_user_foreign` (`user`);

--
-- Indexes for table `admin_settings`
--
ALTER TABLE `admin_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin_smartschoolimport`
--
ALTER TABLE `admin_smartschoolimport`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `articlecategories`
--
ALTER TABLE `articlecategories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `articles_vat_level_foreign` (`vat_level`),
  ADD KEY `articles_picture_foreign` (`picture`);

--
-- Indexes for table `articles_articlecategories`
--
ALTER TABLE `articles_articlecategories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `articles_articlecategories_articles_id_foreign` (`articles_id`),
  ADD KEY `articles_articlecategories_articlecategories_id_foreign` (`articlecategories_id`);

--
-- Indexes for table `attendenceprofile`
--
ALTER TABLE `attendenceprofile`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendenceprofile_user_foreign` (`user`);

--
-- Indexes for table `attendences`
--
ALTER TABLE `attendences`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendences_user_foreign` (`user`);

--
-- Indexes for table `attendence_exceptions`
--
ALTER TABLE `attendence_exceptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attendence_exceptions_user_foreign` (`user`);

--
-- Indexes for table `campuses`
--
ALTER TABLE `campuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cardleasings`
--
ALTER TABLE `cardleasings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cardleasings_card_foreign` (`card`),
  ADD KEY `cardleasings_user_foreign` (`user`),
  ADD KEY `cardleasings_card_leasing_type_foreign` (`card_leasing_type`);

--
-- Indexes for table `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `card_leasing_type`
--
ALTER TABLE `card_leasing_type`
  ADD PRIMARY KEY (`id`),
  ADD KEY `card_leasing_type_pricelevel_foreign` (`pricelevel`);

--
-- Indexes for table `classgroup`
--
ALTER TABLE `classgroup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coaccounts`
--
ALTER TABLE `coaccounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coaccounts_cardleasings`
--
ALTER TABLE `coaccounts_cardleasings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coaccounts_cardleasings_coaccounts_id_foreign` (`coaccounts_id`),
  ADD KEY `coaccounts_cardleasings_cardleasings_id_foreign` (`cardleasings_id`);

--
-- Indexes for table `coaccounts_users`
--
ALTER TABLE `coaccounts_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coaccounts_users_users_id_foreign` (`users_id`),
  ADD KEY `coaccounts_users_coaccounts_id_foreign` (`coaccounts_id`);

--
-- Indexes for table `controleresults`
--
ALTER TABLE `controleresults`
  ADD PRIMARY KEY (`id`),
  ADD KEY `controleresults_controle_foreign` (`controle`),
  ADD KEY `controleresults_event_foreign` (`event`),
  ADD KEY `controleresults_participant_foreign` (`participant`);

--
-- Indexes for table `controles`
--
ALTER TABLE `controles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `controles_event_foreign` (`event`);

--
-- Indexes for table `controle_exceptions`
--
ALTER TABLE `controle_exceptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `controle_exceptions_klas_foreign` (`klas`),
  ADD KEY `controle_exceptions_participant_foreign` (`participant`),
  ADD KEY `controle_exceptions_event_foreign` (`event`);

--
-- Indexes for table `directus_activity`
--
ALTER TABLE `directus_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_activity_collection_foreign` (`collection`);

--
-- Indexes for table `directus_collections`
--
ALTER TABLE `directus_collections`
  ADD PRIMARY KEY (`collection`),
  ADD KEY `directus_collections_group_foreign` (`group`);

--
-- Indexes for table `directus_dashboards`
--
ALTER TABLE `directus_dashboards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_dashboards_user_created_foreign` (`user_created`);

--
-- Indexes for table `directus_fields`
--
ALTER TABLE `directus_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_fields_collection_foreign` (`collection`);

--
-- Indexes for table `directus_files`
--
ALTER TABLE `directus_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_files_uploaded_by_foreign` (`uploaded_by`),
  ADD KEY `directus_files_modified_by_foreign` (`modified_by`),
  ADD KEY `directus_files_folder_foreign` (`folder`);

--
-- Indexes for table `directus_folders`
--
ALTER TABLE `directus_folders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_folders_parent_foreign` (`parent`);

--
-- Indexes for table `directus_migrations`
--
ALTER TABLE `directus_migrations`
  ADD PRIMARY KEY (`version`);

--
-- Indexes for table `directus_notifications`
--
ALTER TABLE `directus_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_notifications_recipient_foreign` (`recipient`),
  ADD KEY `directus_notifications_sender_foreign` (`sender`);

--
-- Indexes for table `directus_panels`
--
ALTER TABLE `directus_panels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_panels_dashboard_foreign` (`dashboard`),
  ADD KEY `directus_panels_user_created_foreign` (`user_created`);

--
-- Indexes for table `directus_permissions`
--
ALTER TABLE `directus_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_permissions_collection_foreign` (`collection`),
  ADD KEY `directus_permissions_role_foreign` (`role`);

--
-- Indexes for table `directus_presets`
--
ALTER TABLE `directus_presets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_presets_collection_foreign` (`collection`),
  ADD KEY `directus_presets_user_foreign` (`user`),
  ADD KEY `directus_presets_role_foreign` (`role`);

--
-- Indexes for table `directus_relations`
--
ALTER TABLE `directus_relations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_relations_many_collection_foreign` (`many_collection`),
  ADD KEY `directus_relations_one_collection_foreign` (`one_collection`);

--
-- Indexes for table `directus_revisions`
--
ALTER TABLE `directus_revisions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_revisions_collection_foreign` (`collection`),
  ADD KEY `directus_revisions_parent_foreign` (`parent`),
  ADD KEY `directus_revisions_activity_foreign` (`activity`);

--
-- Indexes for table `directus_roles`
--
ALTER TABLE `directus_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `directus_sessions`
--
ALTER TABLE `directus_sessions`
  ADD PRIMARY KEY (`token`),
  ADD KEY `directus_sessions_user_foreign` (`user`),
  ADD KEY `directus_sessions_share_foreign` (`share`);

--
-- Indexes for table `directus_settings`
--
ALTER TABLE `directus_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_settings_project_logo_foreign` (`project_logo`),
  ADD KEY `directus_settings_public_foreground_foreign` (`public_foreground`),
  ADD KEY `directus_settings_public_background_foreign` (`public_background`),
  ADD KEY `directus_settings_storage_default_folder_foreign` (`storage_default_folder`);

--
-- Indexes for table `directus_shares`
--
ALTER TABLE `directus_shares`
  ADD PRIMARY KEY (`id`),
  ADD KEY `directus_shares_collection_foreign` (`collection`),
  ADD KEY `directus_shares_role_foreign` (`role`),
  ADD KEY `directus_shares_user_created_foreign` (`user_created`);

--
-- Indexes for table `directus_users`
--
ALTER TABLE `directus_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `directus_users_external_identifier_unique` (`external_identifier`),
  ADD UNIQUE KEY `directus_users_email_unique` (`email`),
  ADD UNIQUE KEY `directus_users_token_unique` (`token`),
  ADD KEY `directus_users_role_foreign` (`role`);

--
-- Indexes for table `directus_webhooks`
--
ALTER TABLE `directus_webhooks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventregistration`
--
ALTER TABLE `eventregistration`
  ADD PRIMARY KEY (`id`),
  ADD KEY `eventregistration_event_foreign` (`event`),
  ADD KEY `eventregistration_participant_foreign` (`participant`),
  ADD KEY `eventregistration_modified_by_foreign` (`modified_by`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_event_type_foreign` (`event_type`),
  ADD KEY `events_modified_by_foreign` (`modified_by`);

--
-- Indexes for table `eventtype`
--
ALTER TABLE `eventtype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `eventtype_modified_by_foreign` (`modified_by`);

--
-- Indexes for table `globalsettings`
--
ALTER TABLE `globalsettings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `globalsettings_default_cardleasing_type_foreign` (`default_cardleasing_type`),
  ADD KEY `globalsettings_default_pricelevel_foreign` (`default_pricelevel`);

--
-- Indexes for table `online_payment`
--
ALTER TABLE `online_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `online_payment_coaccount_foreign` (`coaccount`);

--
-- Indexes for table `online_topoff`
--
ALTER TABLE `online_topoff`
  ADD PRIMARY KEY (`id`),
  ADD KEY `online_topoff_card_leasing_foreign` (`card_leasing`),
  ADD KEY `online_topoff_online_payment_foreign` (`online_payment`);

--
-- Indexes for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orderitems_article_foreign` (`article`),
  ADD KEY `orderitems_order_foreign` (`order`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pricelevels`
--
ALTER TABLE `pricelevels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `prices`
--
ALTER TABLE `prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prices_pricelevel_foreign` (`pricelevel`),
  ADD KEY `prices_article_id_foreign` (`article_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `terminalfunctions`
--
ALTER TABLE `terminalfunctions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `terminals`
--
ALTER TABLE `terminals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `terminals_campus_foreign` (`campus`),
  ADD KEY `terminals_selectedevent_foreign` (`selectedevent`);

--
-- Indexes for table `terminals_terminalfunctions`
--
ALTER TABLE `terminals_terminalfunctions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `terminals_terminalfunctions_terminals_id_foreign` (`terminals_id`),
  ADD KEY `terminals_terminalfunctions_terminalfunctions_id_foreign` (`terminalfunctions_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_terminal_foreign` (`terminal`),
  ADD KEY `transactions_cardleasing_foreign` (`cardleasing`),
  ADD KEY `transactions_order_foreign` (`order`);

--
-- Indexes for table `usergroups`
--
ALTER TABLE `usergroups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usergroups_pricelevel_foreign` (`pricelevel`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_classgroup_foreign` (`classgroup`),
  ADD KEY `users_campus_foreign` (`campus`),
  ADD KEY `users_picture_foreign` (`picture`);

--
-- Indexes for table `users_campuses`
--
ALTER TABLE `users_campuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_classgroup`
--
ALTER TABLE `users_classgroup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_usergroups`
--
ALTER TABLE `users_usergroups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_usergroups_users_id_foreign` (`users_id`),
  ADD KEY `users_usergroups_usergroups_id_foreign` (`usergroups_id`);

--
-- Indexes for table `vat_levels`
--
ALTER TABLE `vat_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `z_configurations`
--
ALTER TABLE `z_configurations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `z_configurations_modified_by_foreign` (`modified_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absences`
--
ALTER TABLE `absences`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_settings`
--
ALTER TABLE `admin_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_smartschoolimport`
--
ALTER TABLE `admin_smartschoolimport`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `articlecategories`
--
ALTER TABLE `articlecategories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `articles_articlecategories`
--
ALTER TABLE `articles_articlecategories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `attendenceprofile`
--
ALTER TABLE `attendenceprofile`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attendences`
--
ALTER TABLE `attendences`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `attendence_exceptions`
--
ALTER TABLE `attendence_exceptions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `campuses`
--
ALTER TABLE `campuses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cardleasings`
--
ALTER TABLE `cardleasings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `card_leasing_type`
--
ALTER TABLE `card_leasing_type`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `classgroup`
--
ALTER TABLE `classgroup`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `coaccounts`
--
ALTER TABLE `coaccounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `coaccounts_cardleasings`
--
ALTER TABLE `coaccounts_cardleasings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `coaccounts_users`
--
ALTER TABLE `coaccounts_users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `controleresults`
--
ALTER TABLE `controleresults`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `controles`
--
ALTER TABLE `controles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `controle_exceptions`
--
ALTER TABLE `controle_exceptions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `directus_activity`
--
ALTER TABLE `directus_activity`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2098;

--
-- AUTO_INCREMENT for table `directus_fields`
--
ALTER TABLE `directus_fields`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1261;

--
-- AUTO_INCREMENT for table `directus_notifications`
--
ALTER TABLE `directus_notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `directus_permissions`
--
ALTER TABLE `directus_permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `directus_presets`
--
ALTER TABLE `directus_presets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `directus_relations`
--
ALTER TABLE `directus_relations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `directus_revisions`
--
ALTER TABLE `directus_revisions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1943;

--
-- AUTO_INCREMENT for table `directus_settings`
--
ALTER TABLE `directus_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `directus_webhooks`
--
ALTER TABLE `directus_webhooks`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `eventregistration`
--
ALTER TABLE `eventregistration`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `eventtype`
--
ALTER TABLE `eventtype`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `globalsettings`
--
ALTER TABLE `globalsettings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `online_payment`
--
ALTER TABLE `online_payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `online_topoff`
--
ALTER TABLE `online_topoff`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `orderitems`
--
ALTER TABLE `orderitems`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `pricelevels`
--
ALTER TABLE `pricelevels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `prices`
--
ALTER TABLE `prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `terminalfunctions`
--
ALTER TABLE `terminalfunctions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `terminals`
--
ALTER TABLE `terminals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `terminals_terminalfunctions`
--
ALTER TABLE `terminals_terminalfunctions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `usergroups`
--
ALTER TABLE `usergroups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users_campuses`
--
ALTER TABLE `users_campuses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_classgroup`
--
ALTER TABLE `users_classgroup`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_usergroups`
--
ALTER TABLE `users_usergroups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `vat_levels`
--
ALTER TABLE `vat_levels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `z_configurations`
--
ALTER TABLE `z_configurations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absences`
--
ALTER TABLE `absences`
  ADD CONSTRAINT `absences_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_picture_foreign` FOREIGN KEY (`picture`) REFERENCES `directus_files` (`id`),
  ADD CONSTRAINT `articles_vat_level_foreign` FOREIGN KEY (`vat_level`) REFERENCES `vat_levels` (`id`);

--
-- Constraints for table `articles_articlecategories`
--
ALTER TABLE `articles_articlecategories`
  ADD CONSTRAINT `articles_articlecategories_articlecategories_id_foreign` FOREIGN KEY (`articlecategories_id`) REFERENCES `articlecategories` (`id`),
  ADD CONSTRAINT `articles_articlecategories_articles_id_foreign` FOREIGN KEY (`articles_id`) REFERENCES `articles` (`id`);

--
-- Constraints for table `attendenceprofile`
--
ALTER TABLE `attendenceprofile`
  ADD CONSTRAINT `attendenceprofile_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Constraints for table `attendences`
--
ALTER TABLE `attendences`
  ADD CONSTRAINT `attendences_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Constraints for table `attendence_exceptions`
--
ALTER TABLE `attendence_exceptions`
  ADD CONSTRAINT `attendence_exceptions_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Constraints for table `cardleasings`
--
ALTER TABLE `cardleasings`
  ADD CONSTRAINT `cardleasings_card_foreign` FOREIGN KEY (`card`) REFERENCES `cards` (`id`),
  ADD CONSTRAINT `cardleasings_card_leasing_type_foreign` FOREIGN KEY (`card_leasing_type`) REFERENCES `card_leasing_type` (`id`),
  ADD CONSTRAINT `cardleasings_user_foreign` FOREIGN KEY (`user`) REFERENCES `users` (`id`);

--
-- Constraints for table `card_leasing_type`
--
ALTER TABLE `card_leasing_type`
  ADD CONSTRAINT `card_leasing_type_pricelevel_foreign` FOREIGN KEY (`pricelevel`) REFERENCES `pricelevels` (`id`);

--
-- Constraints for table `coaccounts_cardleasings`
--
ALTER TABLE `coaccounts_cardleasings`
  ADD CONSTRAINT `coaccounts_cardleasings_cardleasings_id_foreign` FOREIGN KEY (`cardleasings_id`) REFERENCES `cardleasings` (`id`),
  ADD CONSTRAINT `coaccounts_cardleasings_coaccounts_id_foreign` FOREIGN KEY (`coaccounts_id`) REFERENCES `coaccounts` (`id`);

--
-- Constraints for table `coaccounts_users`
--
ALTER TABLE `coaccounts_users`
  ADD CONSTRAINT `coaccounts_users_coaccounts_id_foreign` FOREIGN KEY (`coaccounts_id`) REFERENCES `coaccounts` (`id`),
  ADD CONSTRAINT `coaccounts_users_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `controleresults`
--
ALTER TABLE `controleresults`
  ADD CONSTRAINT `controleresults_controle_foreign` FOREIGN KEY (`controle`) REFERENCES `controles` (`id`),
  ADD CONSTRAINT `controleresults_event_foreign` FOREIGN KEY (`event`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `controleresults_participant_foreign` FOREIGN KEY (`participant`) REFERENCES `users` (`id`);

--
-- Constraints for table `controles`
--
ALTER TABLE `controles`
  ADD CONSTRAINT `controles_event_foreign` FOREIGN KEY (`event`) REFERENCES `events` (`id`);

--
-- Constraints for table `controle_exceptions`
--
ALTER TABLE `controle_exceptions`
  ADD CONSTRAINT `controle_exceptions_event_foreign` FOREIGN KEY (`event`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `controle_exceptions_klas_foreign` FOREIGN KEY (`klas`) REFERENCES `classgroup` (`id`),
  ADD CONSTRAINT `controle_exceptions_participant_foreign` FOREIGN KEY (`participant`) REFERENCES `users` (`id`);

--
-- Constraints for table `directus_collections`
--
ALTER TABLE `directus_collections`
  ADD CONSTRAINT `directus_collections_group_foreign` FOREIGN KEY (`group`) REFERENCES `directus_collections` (`collection`);

--
-- Constraints for table `directus_dashboards`
--
ALTER TABLE `directus_dashboards`
  ADD CONSTRAINT `directus_dashboards_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `directus_files`
--
ALTER TABLE `directus_files`
  ADD CONSTRAINT `directus_files_folder_foreign` FOREIGN KEY (`folder`) REFERENCES `directus_folders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `directus_files_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`),
  ADD CONSTRAINT `directus_files_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `directus_users` (`id`);

--
-- Constraints for table `directus_folders`
--
ALTER TABLE `directus_folders`
  ADD CONSTRAINT `directus_folders_parent_foreign` FOREIGN KEY (`parent`) REFERENCES `directus_folders` (`id`);

--
-- Constraints for table `directus_notifications`
--
ALTER TABLE `directus_notifications`
  ADD CONSTRAINT `directus_notifications_recipient_foreign` FOREIGN KEY (`recipient`) REFERENCES `directus_users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_notifications_sender_foreign` FOREIGN KEY (`sender`) REFERENCES `directus_users` (`id`);

--
-- Constraints for table `directus_panels`
--
ALTER TABLE `directus_panels`
  ADD CONSTRAINT `directus_panels_dashboard_foreign` FOREIGN KEY (`dashboard`) REFERENCES `directus_dashboards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_panels_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `directus_permissions`
--
ALTER TABLE `directus_permissions`
  ADD CONSTRAINT `directus_permissions_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `directus_presets`
--
ALTER TABLE `directus_presets`
  ADD CONSTRAINT `directus_presets_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_presets_user_foreign` FOREIGN KEY (`user`) REFERENCES `directus_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `directus_revisions`
--
ALTER TABLE `directus_revisions`
  ADD CONSTRAINT `directus_revisions_activity_foreign` FOREIGN KEY (`activity`) REFERENCES `directus_activity` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_revisions_parent_foreign` FOREIGN KEY (`parent`) REFERENCES `directus_revisions` (`id`);

--
-- Constraints for table `directus_sessions`
--
ALTER TABLE `directus_sessions`
  ADD CONSTRAINT `directus_sessions_share_foreign` FOREIGN KEY (`share`) REFERENCES `directus_shares` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_sessions_user_foreign` FOREIGN KEY (`user`) REFERENCES `directus_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `directus_settings`
--
ALTER TABLE `directus_settings`
  ADD CONSTRAINT `directus_settings_project_logo_foreign` FOREIGN KEY (`project_logo`) REFERENCES `directus_files` (`id`),
  ADD CONSTRAINT `directus_settings_public_background_foreign` FOREIGN KEY (`public_background`) REFERENCES `directus_files` (`id`),
  ADD CONSTRAINT `directus_settings_public_foreground_foreign` FOREIGN KEY (`public_foreground`) REFERENCES `directus_files` (`id`),
  ADD CONSTRAINT `directus_settings_storage_default_folder_foreign` FOREIGN KEY (`storage_default_folder`) REFERENCES `directus_folders` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `directus_shares`
--
ALTER TABLE `directus_shares`
  ADD CONSTRAINT `directus_shares_collection_foreign` FOREIGN KEY (`collection`) REFERENCES `directus_collections` (`collection`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_shares_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `directus_shares_user_created_foreign` FOREIGN KEY (`user_created`) REFERENCES `directus_users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `directus_users`
--
ALTER TABLE `directus_users`
  ADD CONSTRAINT `directus_users_role_foreign` FOREIGN KEY (`role`) REFERENCES `directus_roles` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `eventregistration`
--
ALTER TABLE `eventregistration`
  ADD CONSTRAINT `eventregistration_event_foreign` FOREIGN KEY (`event`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `eventregistration_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`),
  ADD CONSTRAINT `eventregistration_participant_foreign` FOREIGN KEY (`participant`) REFERENCES `users` (`id`);

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_event_type_foreign` FOREIGN KEY (`event_type`) REFERENCES `eventtype` (`id`),
  ADD CONSTRAINT `events_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`);

--
-- Constraints for table `eventtype`
--
ALTER TABLE `eventtype`
  ADD CONSTRAINT `eventtype_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`);

--
-- Constraints for table `globalsettings`
--
ALTER TABLE `globalsettings`
  ADD CONSTRAINT `globalsettings_default_cardleasing_type_foreign` FOREIGN KEY (`default_cardleasing_type`) REFERENCES `card_leasing_type` (`id`),
  ADD CONSTRAINT `globalsettings_default_pricelevel_foreign` FOREIGN KEY (`default_pricelevel`) REFERENCES `pricelevels` (`id`);

--
-- Constraints for table `online_payment`
--
ALTER TABLE `online_payment`
  ADD CONSTRAINT `online_payment_coaccount_foreign` FOREIGN KEY (`coaccount`) REFERENCES `coaccounts` (`id`);

--
-- Constraints for table `online_topoff`
--
ALTER TABLE `online_topoff`
  ADD CONSTRAINT `online_topoff_card_leasing_foreign` FOREIGN KEY (`card_leasing`) REFERENCES `cardleasings` (`id`),
  ADD CONSTRAINT `online_topoff_online_payment_foreign` FOREIGN KEY (`online_payment`) REFERENCES `online_payment` (`id`);

--
-- Constraints for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD CONSTRAINT `orderitems_article_foreign` FOREIGN KEY (`article`) REFERENCES `articles` (`id`),
  ADD CONSTRAINT `orderitems_order_foreign` FOREIGN KEY (`order`) REFERENCES `orders` (`id`);

--
-- Constraints for table `prices`
--
ALTER TABLE `prices`
  ADD CONSTRAINT `prices_article_id_foreign` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`),
  ADD CONSTRAINT `prices_pricelevel_foreign` FOREIGN KEY (`pricelevel`) REFERENCES `pricelevels` (`id`);

--
-- Constraints for table `terminals`
--
ALTER TABLE `terminals`
  ADD CONSTRAINT `terminals_campus_foreign` FOREIGN KEY (`campus`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `terminals_selectedevent_foreign` FOREIGN KEY (`selectedevent`) REFERENCES `events` (`id`);

--
-- Constraints for table `terminals_terminalfunctions`
--
ALTER TABLE `terminals_terminalfunctions`
  ADD CONSTRAINT `terminals_terminalfunctions_terminalfunctions_id_foreign` FOREIGN KEY (`terminalfunctions_id`) REFERENCES `terminalfunctions` (`id`),
  ADD CONSTRAINT `terminals_terminalfunctions_terminals_id_foreign` FOREIGN KEY (`terminals_id`) REFERENCES `terminals` (`id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_cardleasing_foreign` FOREIGN KEY (`cardleasing`) REFERENCES `cardleasings` (`id`),
  ADD CONSTRAINT `transactions_order_foreign` FOREIGN KEY (`order`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `transactions_terminal_foreign` FOREIGN KEY (`terminal`) REFERENCES `terminals` (`id`);

--
-- Constraints for table `usergroups`
--
ALTER TABLE `usergroups`
  ADD CONSTRAINT `usergroups_pricelevel_foreign` FOREIGN KEY (`pricelevel`) REFERENCES `pricelevels` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_campus_foreign` FOREIGN KEY (`campus`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `users_classgroup_foreign` FOREIGN KEY (`classgroup`) REFERENCES `classgroup` (`id`),
  ADD CONSTRAINT `users_picture_foreign` FOREIGN KEY (`picture`) REFERENCES `directus_files` (`id`);

--
-- Constraints for table `users_usergroups`
--
ALTER TABLE `users_usergroups`
  ADD CONSTRAINT `users_usergroups_usergroups_id_foreign` FOREIGN KEY (`usergroups_id`) REFERENCES `usergroups` (`id`),
  ADD CONSTRAINT `users_usergroups_users_id_foreign` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `z_configurations`
--
ALTER TABLE `z_configurations`
  ADD CONSTRAINT `z_configurations_modified_by_foreign` FOREIGN KEY (`modified_by`) REFERENCES `directus_users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
