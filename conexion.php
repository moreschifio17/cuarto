<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class Conexion {

    public static function conectar() {
        $host = "localhost";
        $port = "5432";
        $dbname = "cuarto";
        $user = "postgres";
        $password = "";
        $cn = pg_connect("host='$host' port='$port' dbname='$dbname' user='$user' password='$password'");
        return $cn;
    }
    public static function conectar_quinto() {
        $host = "localhost";
        $port = "5432";
        $dbname = "quinto";
        $user = "postgres";
        $password = "";
        $cn = pg_connect("host='$host' port='$port' dbname='$dbname' user='$user' password='$password'");
        return $cn;
    }

}
