<?php
include 'conexion.php';
$conexion_cuarto = Conexion::conectar();
$conexion_quinto = Conexion::conectar_quinto();
$paises_cuarto = pg_fetch_all(pg_query($conexion_cuarto, "SELECT * FROM paises ORDER BY id_pais"));
$paises_quinto = pg_fetch_all(pg_query($conexion_quinto, "SELECT * FROM paises ORDER BY id_pais"));
?>
<label>Paises cuarto</label>
<table border="1" width="100%">
    <thead>
        <tr>
            <th>Codigo</th>
            <th>Descripcion</th>
        </tr>
    </thead>
    <tbody>
        <?php
        if (!empty($paises_cuarto)) {
            foreach ($paises_cuarto as $p) {
                ?>
                <tr>
                    <td><?= $p['id_pais'] ?></td>
                    <td><?= $p['pais_descrip'] ?></td>

                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td colspan="2">No hay registros</td>
            </tr>
        <?php } ?>

    </tbody>
</table>
<br/>
<br/>
<br/>
<label>Paises quinto</label>
<table border="1" width="100%">
    <thead>
        <tr>
            <th>Codigo</th>
            <th>Descripcion</th>
        </tr>
    </thead>
    <tbody>
        <?php
        if (!empty($paises_quinto)) {
            foreach ($paises_cuarto as $q) {
                ?>
                <tr>
                    <td><?= $q['id_pais'] ?></td>
                    <td><?= $q['pais_descrip'] ?></td>

                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td colspan="2" align="center">No hay registros</td>
            </tr>
        <?php } ?>

    </tbody>
</table>
<?php
if (empty($paises_quinto)) {

    foreach ($paises_cuarto as $p) {
        $id_pais = $p['id_pais'];
        $pais_descrip = $p['pais_descrip'];
        $pais_gentilicio = $p['pais_gentilicio'];
        $pais_codigo = $p['pais_codigo'];
        $estado = $p['estado'];
        $auditoria = $p['auditoria'];
        pg_query($conexion_quinto, "INSERT INTO paises (id_pais,pais_descrip,pais_gentilicio,pais_codigo,estado, auditoria) "
                . "values ($id_pais,'$pais_descrip','$pais_gentilicio','$pais_codigo','$estado','$auditoria')");
    }
}

$paises = null;
if (!empty($paises_cuarto)) {
    foreach ($paises_cuarto as $p) {
        $paises[$p['pais_descrip']]['descripcion'] = $p['pais_descrip'];
        $paises[$p['pais_descrip']]['existe_cuarto'] = TRUE;
        $paises[$p['pais_descrip']]['existe_quinto'] = FALSE;
    }
}
if (!empty($paises_quinto)) {
    foreach ($paises_quinto as $p) {
        if (!isset($paises[$p['pais_descrip']])) {
        $paises[$p['pais_descrip']]['existe_cuarto'] = FALSE;
 
        }
        $paises[$p['pais_descrip']]['descripcion'] = $p['pais_descrip'] . "<br/>";
        $paises[$p['pais_descrip']]['existe_quinto'] = TRUE;

        }
}
?>
<br/>
<br/>
<br/>
<label>Cobinacion de paises</label>
<table border="1" width="100%">
    <thead>
        <tr>
            <th>CODIGO</th>
            <th>DESCRIPCION</th>
            <th>BD CUARTO</th>
            <th>BD QUINTO</th>
        </tr>
    </thead>
    <tbody>
        <?php if (!empty($paises)) {
            $codigo = 0; ?>
    <?php foreach ($paises as $p) {
        $codigo++; ?>
                <tr>
                    <td><?php echo $codigo; ?></td>
                    <td><?php echo $p['descripcion']; ?></td>
                    <td><?php if($p['existe_cuarto']){ echo "SI";} else{echo "NO";} ?></td>
                    <td><?php if($p['existe_quinto']){ echo "SI";} else{echo "NO";} ?></td>
                </tr>
            <?php } ?>
<?php } else { ?>
                <tr>
                    <td colspan="2">No hay datos de las bd</td>
                </tr>
<?php } ?>
    </tbody>
</table>
