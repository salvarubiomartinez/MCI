-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-04-2017 a las 09:08:48
-- Versión del servidor: 5.7.14
-- Versión de PHP: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mci`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adhesionesmanifiesto`
--

CREATE TABLE `adhesionesmanifiesto` (
  `data` json NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `denuncias`
--

CREATE TABLE `denuncias` (
  `data` json NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `donaciones`
--

CREATE TABLE `donaciones` (
  `data` json NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socios`
--

CREATE TABLE `socios` (
  `data` json NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `socios`
--

INSERT INTO `socios` (`data`) VALUES
('{"hooa": "deded"}'),
('{"info": "frfrfrfrfrf", "usuarioId": 1}'),
('{"info": "hola", "usuarioId": 1}'),
('{"info": "hola", "usuarioId": 1}'),
('{"hooa": "deded"}'),
('{"info": "eeee", "usuarioId": 1}'),
('{"info": "esta es mi colaboracion", "usuarioId": 1}'),
('{"ddd": "fff"}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` char(60) NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `locked`) VALUES
(1, 'maria@yahoo.es', '$2y$10$CWbzk9zdZijbzNOkI4SmuOBTdC3nH4.muMlA/v9PTe41qDXv.sK4C', 0),
(2, 'pepe@yahoo.es', '$2y$10$gW73oscXI9zsB.DDIFca1uK9MVd5Y.DgqXflZ6Kefnsi8nQj.Rwom', 0),
(3, 'pepe1@yahoo.es', '$2y$10$Z1nLCEFh2oxJAZ6nPES1q.Vd3FoUsGOn5Ka0clGyDghkQTjE0JHV6', 0),
(4, 'jaime@yahoo.es', '$2y$10$udvM9S0u97Yx6XBuGvJLEeT9qc4RzAR5bLAUPIKZlF//OZUFkJHWm', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
