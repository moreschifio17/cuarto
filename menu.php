<?php
$conexion = Conexion::conectar();
//$modulos = pg_fetch_all(pg_query($conexion, "SELECT * FROM modulos ORDER BY id_mod"));
//$paginas = null;
//$lista_paginas = pg_fetch_all(pg_query($conexion, "SELECT * FROM paginas ORDER BY id_mod, id_pag"));
//;
//foreach ($lista_paginas as $l) {
//    $paginas[$l['id_mod']][$l['id_pag']]['id_pag'] = ['id_pag'];
//    $paginas[$l['id_mod']][$l['id_pag']]['pag_descrip'] = ['pag_descrip'];
//    $paginas[$l['id_mod']][$l['id_pag']]['pag_ubicacion'] = ['pag_ubicacion'];
//    $paginas[$l['id_mod']][$l['id_pag']]['pag_iconos'] = ['pag_iconos'];
//    $paginas[$l['id_mod']][$l['id_pag']]['id_mod'] = ['id_mod'];
//    
//}
$permisos = pg_fetch_all(pg_query($conexion, "SELECT * FROM v_permisos WHERE id_gru = ".$_SESSION['id_gru']." AND estado = 'ACTIVO' AND id_ac = 1 ORDER BY mod_orden, pag_descrip;"));
$modulos = null;
$paginas = null;
if (!empty($permisos)) {
    foreach ($permisos as $p) {
        $modulos[$p['id_mod']]['id_mod'] = $p['id_mod'];
        $modulos[$p['id_mod']]['mod_descrip'] = $p['mod_descrip'];
        $modulos[$p['id_mod']]['mod_icono'] = $p['mod_icono'];
        $paginas[$p['id_mod']][$p['id_pag']]['id_pag'] = $p['id_pag'];
        $paginas[$p['id_mod']][$p['id_pag']]['pag_descrip'] = $p['pag_descrip'];
        $paginas[$p['id_mod']][$p['id_pag']]['pag_ubicacion'] = $p['pag_ubicacion'];
        $paginas[$p['id_mod']][$p['id_pag']]['pag_iconos'] = $p['pag_iconos'];
    }
}
?>
<!-- MENU INICIO-->
<aside class="main-sidebar elevation-4 sidebar-light-primary">
    <a href="/cuarto/inicio.php" class="brand-link navbar-primary">
        <img src="/cuarto/iconos/icono2.jpg" alt="LOGO" class="brand-image img-circle elevation-5">
        <span class="brand-text text-white">Ñapu'a Solution</span>
    </a>
    <div class="sidebar">
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image" class="img-circle ejevation-2" alt="Imagen de usuario">
                <img src="<?php echo $_SESSION['usu_imagen']; ?>" class="img-circle ejevation-2">
            </div>
            <div class="info">
                <a class="d-block">
                    <?php echo $_SESSION['per_nombre'] . " " . $_SESSION['per_apellido'] ?>
                    <br/><span class="text-muted"><?php echo $_SESSION['usu_login'] ?></span>
                </a>
            </div>
        </div>

        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image" class="img-circle ejevation-2" alt="Imagen de sucursal">
                <img src="<?php echo $_SESSION['suc_imagen']; ?>" class="img-circle ejevation-2">
            </div>
            <div class="info">
                <a class="d-block">
                    <?php echo $_SESSION['suc_nombre']; ?>

                </a>

            </div>
        </div>
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                <?php if (!empty($modulos)) { ?>
                    <?php foreach ($modulos as $n) { ?> 
                        <li class="nav-item has-treeview">
                            <a href="#" class="nav-link">
                                <i class="nav-icon <?php echo $n['mod_icono'] ?>">
                                </i>
                                <p> <?php echo $n['mod_descrip'] ?>
                                    <i class="right fas fa-angle-down"></i>
                                </p>
                            </a>

                            <!-- INICIO AGREGADO 2021-08-08-03-->
                            <ul class="nav nav-treeview">
                                <?php if (isset($paginas[$n['id_mod']])) { ?>
                                    <?php foreach ($paginas[$n['id_mod']] as $p) { ?>
                                        <li class="nav-item">
                                            <a href="<?php echo $p['pag_ubicacion']; ?>" class="nav-link">
                                                <i class="<?php echo $p['pag_iconos']; ?>" class="nav-icon"></i>
                                                <p><?php echo $p['pag_descrip']; ?></p>
                                            </a>
                                        </li>
                                    <?php } ?>
                                <?php } else { ?>
                                    <li class="nav-item">
                                        <a>
                                            <p>
                                                <label>
                                                    <i class="fa fa-exclamation-circle"></i>
                                                    No se registran paginas para este modulo
                                                </label>
                                            </p>
                                        </a>
                                    </li>
                                <?php } ?>
                            </ul>
                            <!-- FIN AGREGADO 2021-08-08-03-->

                        </li>
                    <?php } ?>
                <?php } else { ?>
                    <li>
                        <a>
                            <label class="text-danger">
                                <i class="fa fa-exclamation-circle"></i>
                                No se encontraron modulos
                            </label>
                        </a>
                    </li>
                <?php } ?>
            </ul> 
        </nav>

</aside>