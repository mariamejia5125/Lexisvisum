-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 02-06-2026 a las 21:27:28
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `lexis_visum`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carts`
--

CREATE TABLE `carts` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `carts`
--

INSERT INTO `carts` (`id`, `user_id`) VALUES
(1, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cart_items`
--

CREATE TABLE `cart_items` (
  `id` bigint NOT NULL,
  `cart_id` bigint DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `plan_id` bigint DEFAULT NULL,
  `quantity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `plan_id`, `quantity`) VALUES
(1, 1, 91, NULL, 1),
(3, 1, 97, NULL, 1),
(4, 1, NULL, 2, 1),
(5, 1, 107, NULL, 1),
(6, 1, NULL, 4, 1),
(7, 1, 102, NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `device_maintenance`
--

CREATE TABLE `device_maintenance` (
  `id` bigint NOT NULL,
  `product_id` int DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `maintenance_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `details` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(255) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_details`
--

CREATE TABLE `order_details` (
  `id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_statuses`
--

CREATE TABLE `order_statuses` (
  `id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payments`
--

CREATE TABLE `payments` (
  `id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `method` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `billing_info` json DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `version` varchar(255) NOT NULL,
  `category_id` int DEFAULT NULL,
  `inventory` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `Image` varchar(255) NOT NULL
) ;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `version`, `category_id`, `inventory`, `price`, `Image`) VALUES
(76, 'Lexis Visum Focus Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 3, 297, 295.69, 'product_1.jpg'),
(77, 'Lexis Visum Carry Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 1, 108, 765.53, 'product_2.jpg'),
(78, 'Lexis Visum Learning Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 3, 22, 564.88, 'product_3.jpg'),
(80, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Kids', 2, 39, 337.73, 'product_5.jpg'),
(81, 'Lexis Visum Travel Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 3, 254, 431.17, 'product_6.jpg'),
(82, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 2, 136, 776.13, 'product_7.jpg'),
(83, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 3, 212, 521.40, 'product_8.jpg'),
(84, 'Lexis Visum Text Reader', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 1, 171, 66.07, 'product_9.jpg'),
(85, 'Lexis Visum Pro Vision', 'Professional version with enhanced OCR performance and advanced accessibility features.', 'Pro', 1, 110, 593.82, 'product_10.jpg'),
(86, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 3, 214, 344.60, 'product_11.jpg'),
(87, 'Lexis Visum Charging Dock', 'Charging dock that provides fast and secure power for Lexis Visum smart glasses.', 'Kids', 3, 134, 579.58, 'product_12.jpg'),
(88, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 3, 77, 292.22, 'product_13.jpg'),
(89, 'Lexis Visum Processing Unit', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Edu', 1, 289, 447.21, 'product_14.jpg'),
(90, 'Lexis Visum Text Reader', 'Professional version with enhanced OCR performance and advanced accessibility features.', 'Pro', 2, 56, 491.07, 'product_15.jpg'),
(91, 'Lexis Visum Classroom Glasses', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 1, 107, 621.72, 'product_16.jpg'),
(92, 'Lexis Visum Classroom Glasses', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 3, 114, 877.76, 'product_17.jpg'),
(93, 'Lexis Visum Classroom Glasses', 'Smart glasses optimized for children with learning support and real-time text assistance.', 'Kids', 3, 178, 799.01, 'product_18.jpg'),
(94, 'Lexis Visum Mobile Reader', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 1, 234, 336.27, 'product_19.jpg'),
(95, 'Lexis Visum Study Glasses', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 3, 268, 562.24, 'product_20.jpg'),
(96, 'Lexis Visum AI Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 1, 32, 414.80, 'product_21.jpg'),
(97, 'Lexis Visum Study Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 2, 107, 92.10, 'product_22.jpg'),
(98, 'Lexis Visum Travel Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Kids', 1, 135, 624.12, 'product_23.jpg'),
(99, 'Lexis Visum Smart Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 2, 170, 454.69, 'product_24.jpg'),
(100, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Essential', 2, 120, 849.26, 'product_25.jpg'),
(101, 'Lexis Visum Pocket Processor', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Essential', 1, 222, 665.55, 'product_26.jpg'),
(102, 'Lexis Visum AI Glasses', 'Professional version with enhanced OCR performance and advanced accessibility features.', 'Pro', 2, 92, 80.22, 'product_27.jpg'),
(103, 'Lexis Visum Pro Vision', 'Smart glasses optimized for children with learning support and real-time text assistance.', 'Kids', 3, 143, 186.55, 'product_28.jpg'),
(104, 'Lexis Visum Classroom Glasses', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 2, 298, 653.52, 'product_29.jpg'),
(105, 'Lexis Visum Travel Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Pro', 1, 226, 113.58, 'product_30.jpg'),
(106, 'Lexis Visum AI Glasses', 'Smart glasses optimized for children with learning support and real-time text assistance.', 'Kids', 2, 111, 98.74, 'product_31.jpg'),
(107, 'Lexis Visum Study Glasses', 'Professional version with enhanced OCR performance and advanced accessibility features.', 'Pro', 3, 134, 663.68, 'product_32.jpg'),
(108, 'Lexis Visum Smart Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 2, 278, 757.45, 'product_33.jpg'),
(109, 'Lexis Visum Smart Glasses', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 3, 176, 793.91, 'product_34.jpg'),
(110, 'Lexis Visum Processing Unit', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Essential', 2, 51, 65.61, 'product_35.jpg'),
(111, 'Lexis Visum Travel Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Pro', 3, 47, 812.88, 'product_36.jpg'),
(112, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Pro', 1, 112, 845.89, 'product_37.jpg'),
(113, 'Lexis Visum Mobile Reader', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 1, 85, 510.30, 'product_38.jpg'),
(114, 'Lexis Visum Mobile Reader', 'Smart glasses with OCR and AI technology that read and interpret text in real time.', 'Essential', 3, 53, 814.31, 'product_39.jpg'),
(115, 'Lexis Visum Processing Unit', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Edu', 1, 179, 529.70, 'product_40.jpg'),
(116, 'Lexis Visum Carry Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Pro', 3, 166, 563.64, 'product_41.jpg'),
(117, 'Lexis Visum Carry Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Edu', 2, 246, 53.31, 'product_42.jpg'),
(118, 'Lexis Visum Pocket Processor', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Essential', 2, 186, 832.42, 'product_43.jpg'),
(119, 'Lexis Visum Classroom Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 3, 264, 257.85, 'product_44.jpg'),
(120, 'Lexis Visum Processing Unit', 'Portable processing unit that powers OCR and AI text recognition for Lexis Visum glasses.', 'Pro', 2, 287, 831.19, 'product_45.jpg'),
(121, 'Lexis Visum Vision Assist', 'Smart glasses optimized for children with learning support and real-time text assistance.', 'Kids', 2, 189, 315.76, 'product_46.jpg'),
(122, 'Lexis Visum Text Reader', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 1, 239, 86.73, 'product_47.jpg'),
(123, 'Lexis Visum Mobile Reader', 'Professional version with enhanced OCR performance and advanced accessibility features.', 'Pro', 2, 125, 528.73, 'product_48.jpg'),
(124, 'Lexis Visum Study Glasses', 'Educational smart glasses designed to assist students with reading and comprehension.', 'Edu', 2, 78, 374.67, 'product_49.jpg'),
(125, 'Lexis Visum Protective Case', 'Protective travel case designed to safely store and transport Lexis Visum smart glasses.', 'Essential', 3, 156, 454.47, 'product_50.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product_categories`
--

CREATE TABLE `product_categories` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `product_categories`
--

INSERT INTO `product_categories` (`id`, `name`) VALUES
(1, 'Smart Glasses'),
(2, 'Accesories'),
(3, 'Processing Devices');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shipping_addresses`
--

CREATE TABLE `shipping_addresses` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `plan_id` bigint DEFAULT NULL,
  `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration` int NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `name`, `price`, `duration`, `description`) VALUES
(1, 'Executive Care Basic', 89.99, 30, 'Garantia extendida basica y soporte por correo'),
(2, 'Executive Care Plus', 149.99, 30, 'Reparaciones menores y soporte prioritario'),
(3, 'Executive Secure', 199.99, 30, 'Proteccion contra fallos tecnicos y reemplazo parcial'),
(4, 'Executive Assist', 249.99, 30, 'Diagnostico remoto y mantenimiento preventivo'),
(5, 'Executive Priority', 299.99, 180, 'Atencion prioritaria 24/7 y soporte especializado'),
(6, 'Executive Protect', 1299.99, 180, 'Cobertura por daños accidentales limitados\r\n'),
(7, 'Executive Protect', 1299.99, 180, 'Cobertura por daños accidentales limitados\r\n'),
(8, 'Executive Advanced Care', 1799.99, 365, 'Limpieza, calibracion y revision anual incluida\r\n'),
(9, 'Executive Elite Support', 2999.99, 365, 'Reemplazo rapido de componentes y soporte premium\r\n');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `issue_description` text NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `user_type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `user_type`) VALUES
(6, 'Maria fernanda 3', 'scrypt:32768:8:1$6SB95toiPh6O35uj$24eda051fe7b6cab6d28b0a7eb373ad3db84b63fe7494698a2bf99006609377869148b4caee28d7a6f3d347061e555c634dc8dc5cd45092c05c99defffeea3c8', 'mafermejialz94.7@gmail.com', 'U'),
(7, 'Maria Mejia', 'scrypt:32768:8:1$XsAItEWVDHJgwg9b$81367b7e8a243d16e9c63cd1ab624bc2a92d7394bd66b75c8f1ac3f2a0aa4ffb066be3e1a4cb688575f511b42c6879c092d7027fa0a8a730e1f02e8621d59913', 'que@gmail.com', 'U'),
(8, 'asdfghjkl', 'scrypt:32768:8:1$wlXa1SU8RR3lzTUR$e6c3518ba2715d4ed1a7ef7226475f44dc58fe82eaf7b783469681da243e6f91a26d4725bfc2b7826773ee4943618319be89a37915cf50f397dbf9798aedd633', 'nonono@gmail.com', 'A'),
(12, 'Maria fernanda', 'scrypt:32768:8:1$kPPjy13HfXLqxg8G$4864f1a695f8a71d92ca833164d747fd633624412fe9b25f220cd6e44cc8ed0207c92c3bf69d42f0db0ad146cb000e7fce05e92ff895c32147528b0fe5111a0c', 'cocoroll0609@gmail.com', 'U'),
(14, 'coquito', 'scrypt:32768:8:1$p5UpO5rrnzri2rVK$e8fe51cca8f08957119279e4b79e925cb4b7ca492f0687a3bc4fe2827707f4461056f66e3f7e93b5bf3f787649954991f9674154069fc08079a374351390d8be', 'maria.mejia5125@alumnos.udg.mx', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_product`
--

CREATE TABLE `user_product` (
  `id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `product_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `warranty_end` timestamp NULL DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `user_product`
--

INSERT INTO `user_product` (`id`, `user_id`, `product_id`, `serial_number`, `purchase_date`, `warranty_end`, `status`) VALUES
(1, 12, 84, 'LVES8416899', '2026-06-02 01:50:02', '2027-06-02 01:50:02', 'active'),
(2, 12, 87, 'LVKI-87-3-9754', '2026-06-02 13:29:32', '2027-06-02 13:29:32', 'active'),
(3, 12, 76, 'LVED-76-3-8463', '2026-06-02 15:34:40', '2027-06-02 15:34:40', 'active');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `warranties`
--

CREATE TABLE `warranties` (
  `id` bigint NOT NULL,
  `product_id` int DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_ibfk_1` (`cart_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indices de la tabla `device_maintenance`
--
ALTER TABLE `device_maintenance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indices de la tabla `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indices de la tabla `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_key` (`username`),
  ADD UNIQUE KEY `users_email_key` (`email`);

--
-- Indices de la tabla `user_product`
--
ALTER TABLE `user_product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serial_number` (`serial_number`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `user_product_ibfk_2` (`product_id`);

--
-- Indices de la tabla `warranties`
--
ALTER TABLE `warranties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carts`
--
ALTER TABLE `carts`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `device_maintenance`
--
ALTER TABLE `device_maintenance`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `order_statuses`
--
ALTER TABLE `order_statuses`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `user_product`
--
ALTER TABLE `user_product`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `warranties`
--
ALTER TABLE `warranties`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `device_maintenance`
--
ALTER TABLE `device_maintenance`
  ADD CONSTRAINT `device_maintenance_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `device_maintenance_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD CONSTRAINT `order_statuses_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD CONSTRAINT `shipping_addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `subscriptions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `user_product`
--
ALTER TABLE `user_product`
  ADD CONSTRAINT `user_product_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_product_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `warranties`
--
ALTER TABLE `warranties`
  ADD CONSTRAINT `warranties_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `warranties_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
