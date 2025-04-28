-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 28, 2025 at 03:26 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_mie`
--

-- --------------------------------------------------------

--
-- Table structure for table `meja`
--

CREATE TABLE `meja` (
  `idMeja` int(11) NOT NULL,
  `idPelanggan` int(11) NOT NULL,
  `status` enum('available','taken') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meja`
--

INSERT INTO `meja` (`idMeja`, `idPelanggan`, `status`) VALUES
(1, 0, 'available'),
(2, 0, 'available'),
(3, 0, 'available'),
(4, 0, 'available'),
(5, 0, 'available'),
(6, 0, 'available'),
(7, 0, 'available'),
(8, 0, 'available'),
(9, 0, 'available'),
(10, 0, 'available'),
(11, 0, 'available'),
(12, 0, 'available'),
(13, 0, 'available'),
(14, 0, 'available'),
(15, 0, 'available'),
(16, 0, 'available'),
(17, 0, 'available'),
(18, 0, 'available'),
(19, 0, 'available'),
(20, 0, 'available'),
(21, 0, 'available'),
(22, 0, 'available'),
(23, 0, 'available'),
(24, 0, 'available'),
(25, 0, 'available'),
(26, 0, 'available'),
(27, 0, 'available'),
(28, 0, 'available'),
(29, 0, 'available');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `idMenu` int(11) NOT NULL,
  `namaMenu` text NOT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`idMenu`, `namaMenu`, `harga`, `stok`) VALUES
(8, 'Tongkol', 1000, 10),
(10, 'Sayur Asem', 10000, 10),
(11, 'Nasi Goreng Maklimah Biadab', 200000, 0),
(12, 'Es Buah', 10000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `idPelanggan` int(11) NOT NULL,
  `fullName` text NOT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `noHandphone` int(11) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`idPelanggan`, `fullName`, `gender`, `noHandphone`, `address`) VALUES
(1, 'Heriko Farely Putra', 'Male', 2147483647, 'Males'),
(2, 'Jak', 'Female', 1231231241, 'Jsii');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `idPesanan` int(11) NOT NULL,
  `idMeja` int(11) DEFAULT NULL,
  `idPelanggan` int(11) DEFAULT NULL,
  `idUser` int(11) DEFAULT NULL,
  `jumlah` text NOT NULL,
  `idMenu` text NOT NULL,
  `createdAt` date NOT NULL,
  `status` enum('PAID','UNPAID') NOT NULL,
  `total` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`idPesanan`, `idMeja`, `idPelanggan`, `idUser`, `jumlah`, `idMenu`, `createdAt`, `status`, `total`) VALUES
(15, 2, 1, 1, '1,1', 'Tongkol (x1), Es Alpukat (x1)', '2025-04-28', 'PAID', 0),
(17, 2, 2, 2, '1', 'Sayur Asem (x1)', '2025-04-28', 'PAID', 10000);

--
-- Triggers `pesanan`
--
DELIMITER $$
CREATE TRIGGER `set_meja_available` AFTER DELETE ON `pesanan` FOR EACH ROW BEGIN
  UPDATE meja
  SET status = 'available', idPelanggan = NULL
  WHERE idMeja = OLD.idMeja;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `set_meja_not_available` AFTER INSERT ON `pesanan` FOR EACH ROW BEGIN
  UPDATE meja
  SET status = 'taken', idPelanggan = NEW.idPelanggan
  WHERE idMeja = NEW.idMeja;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `IdTransaksi` int(11) NOT NULL,
  `idPesanan` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `bayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL,
  `status` enum('PAID','UNPAID') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`IdTransaksi`, `idPesanan`, `total`, `bayar`, `kembalian`, `status`) VALUES
(1347, 17, 10000, 90000, 80000, 'PAID');

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `update_meja_and_pesanan_status` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
  IF NEW.status = 'PAID' THEN
    -- Update meja jadi available
    UPDATE meja
    SET status = 'available',
        idPelanggan = NULL
    WHERE idMeja = (
      SELECT idMeja
      FROM pesanan
      WHERE idPesanan = NEW.idPesanan
      LIMIT 1
    );

    -- Update pesanan jadi PAID
    UPDATE pesanan
    SET status = 'PAID'
    WHERE idPesanan = NEW.idPesanan;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role` enum('admin','waiter','kasir','owner') NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_fullname` text NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role`, `user_name`, `user_fullname`, `user_password`, `created_at`) VALUES
(7, 'admin', 'heriko', 'Heriko Farely Putra', '$2b$10$6roiE5TW0Uoi2WM/mInFq./ayfVl/X16/.dHIKXrayEm3c2ds9xcK', '2025-04-17 08:20:12'),
(42, 'waiter', 'gunawanzucky', 'Gunawan Zaki Budi Santoso', '$2b$10$MbMNoMUY6FKamID04bQEuuTQTgo4FoXRgPg2bh/EtTDLr/T/dW9oa', '2025-04-17 09:45:47'),
(43, 'admin', 'markus', 'User', '$2b$10$KnZ32qbhlstwePSzX4mR7.iVEX4ulwPFcZSXnoXbfydtjsgjHQBSu', '2025-04-17 09:51:37'),
(44, 'admin', 'gigi', 'User', '$2b$10$A51Fb1zmrSWLDSWGtglwDe6a9q1ieR.BDF625O3mm.YuCiCd72An2', '2025-04-17 09:51:40'),
(45, 'admin', 'rafel', 'User', '$2b$10$nwuF69st.YgkL3r/Z82YDekXP9AhaZxzkv3ZlV/vuY.JHxYQYZy0y', '2025-04-17 09:51:43'),
(46, 'admin', 'abdu', 'User', '$2b$10$DKCn8ABkh/bMP3ywCEYqJOs/AhQKSzqEWzgser6vuQbKe2P./bnhq', '2025-04-17 09:51:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `meja`
--
ALTER TABLE `meja`
  ADD PRIMARY KEY (`idMeja`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`idMenu`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`idPelanggan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`idPesanan`),
  ADD KEY `idMeja` (`idMeja`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`IdTransaksi`),
  ADD UNIQUE KEY `idPesanan` (`idPesanan`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `meja`
--
ALTER TABLE `meja`
  MODIFY `idMeja` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `idMenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `idPelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `idPesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `IdTransaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1348;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`idMeja`) REFERENCES `meja` (`idMeja`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
