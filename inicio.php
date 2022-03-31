<?php
include './conexion.php';
include './session.php';
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Ñapu'a Solution</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="/cuarto/iconos/icono2.jpg" type="jpg">
        <link rel="stylesheet" href="/cuarto/estilo/dist/css/adminlte.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/font-google.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/toastr/toastr.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/plugins/select2/css/select2.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla1.min.css">
        <link rel="stylesheet" href="/cuarto/estilo/descarga/tabla2.min.css">
        <link rel="stylesheet" href="/cuarto/vistaprevia.css">
        
    </head>
    <body class="hold-transition sidebar-mini layout-fixed sidebar-collapse">
        <div class="wrapper">
            <!-- CABECERA INICIO-->
            <?php include 'cabecera.php'; ?>
            <!-- CABECERA FINAL-->
            <?php include 'menu.php'; ?>
            <div class="content-wrapper">
                <div class="content-header">
                    <div class="container-fluid">
                        <div class="row mb-2">
                            <div class="col-sm-6">
                                <h1 id="titulo" class="m-0 text-dark">Ñapu'a Solution</h1>
                                </div>
                                <div class="col-sm-6">
                                    <ol class="breadcrumb float-sm-right">
                                        <li class="breadcrumb-item active">Inicio</li>
                                    </ol>
                                </div>
                        </div>
                    </div>
                </div>
            
            <section class="content">
                <div class="container-fluid">
                    <center>
                        <button onclick="prev()" class="btn btn-info"><i class="fa fa-angle-double-left"></i></button>&nbsp;&nbsp;
                        <img id="slider" src="imagenes/usuarios/5.jpg" width="450" height="450" alt="icono2"/>&nbsp;&nbsp;
                         <button onclick="next()" class="btn btn-info"><i class="fa fa-angle-double-right"></i></button>
                    </center>
                    

                </div>
            </section>
          </div>
            <footer class="main-footer">
                <strong>Copyright &copy; 2021 <a href="#">Ñapu'a Solution</a></strong>
            </footer>
        </div>
        <script src="/cuarto/estilo/plugins/jquery/jquery.min.js"></script>
        <script src="/cuarto/estilo/plugins/jquery-ui/jquery-ui.min.js"></script>
        <script> $.widget.bridge('uibutton', $.ui.button)</script>
        <script src="/cuarto/estilo/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="/cuarto/estilo/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
        <script src="/cuarto/estilo/dist/js/adminlte.js"></script>
        <script src="/cuarto/iconos/fontawesome.js"></script>
        <script src="/cuarto/estilo/plugins/fastclick/fastclick.js"></script>
        <script src="/cuarto/estilo/plugins/sweetalert2/sweetalert2.min.js"></script>
        <script src="/cuarto/estilo/plugins/toastr/toastr.min.js"></script>
        <script src="/cuarto/estilo/plugins/select2/js/select2.full.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla1.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla2.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla3.min.js"></script>
        <script src="/cuarto/estilo/descarga/tabla4.min.js"></script>
        <script src="vista.js"></script>
        <?php include './mensaje.php';?>
    </body>
</html>