<?php
session_start();
if (isset($_SESSION['id_usu'])) {
    if (!($_SESSION['id_usu'] == null || $_SESSION['id_usu'] == '' )) {
        header("Location: /cuarto/inicio.php");
    }
}

//if (isset($_SESSION['mensaje'])) {
//    if ($_SESSION['mensaje'] == null || $_SESSION['mensaje'] == '') {
//        
//    } else {
//        $mensaje = $_SESSION['mensaje'];
//        $_SESSION['mensaje'] = '';
//    }
//}
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Ñapu'a Solution</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="/cuarto/iconos/icono2.jpg" type="image/x-icon">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/dist/css/adminlte.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/font-google.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/toastr/toastr.min.css">
    </head>
    <body class="hold-transition login-page">
        <div class="login-box card-primary text-center">
            <div class="card-header">
                <h3 class="card-title">Ñapu'a Solution <i class="fa fa-file" aria-hidden="true"></i></h3>
            </div>
            <div class="card card-info">
                <div class="card-body">
                    <p></p>
                    <form action="login.php" method="post">
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="far fa-user"></i>
                                </span>
                            </div>
                            <input type="text" required="" name="usuario" class="form-control" placeholder="Usuario" autocomplete="off" autofocus="">
                        </div>
                        <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fas fa-key"></i>
                                </span>
                            </div>
                            <input type="password" required="" name="contrasena" class="form-control" placeholder="Contraseña">
                        </div>
                        <div class="row">
                            <button type="submit" class="btn btn-primary btn-block btn-flat">Ingresar</button>
                        </div>
                        <?php
                        if (isset($mensaje)) {
                            echo "<br/><div class='alert alert-danger'> <i class='fa fa-exclamation-circle'></i> $mensaje</div>";
                        }
                        ?>
                    </form>
                </div>
            </div>
        </div>
        <script src="/cuarto/iconos/fontawesome.js"></script>
        <script src="/cuarto/estilo/plugins/jquery/jquery.min.js"></script>
        <script src="/cuarto/estilo/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="/cuarto/estilo/plugins/fastclick/fastclick.js"></script>
        <script src="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.js"></script>
        <script src="/cuarto/estilo/plugins/toastr/toastr.min.js"></script>
        <?php include './mensaje.php';?>
    </body>
</html>