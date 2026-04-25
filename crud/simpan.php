<?php
include 'koneksi.php';

mysqli_query($conn, "INSERT INTO resep_obat 
(nama_pasien, nama_obat, dosis, aturan_pakai, keterangan)
VALUES
('$_POST[nama_pasien]', '$_POST[nama_obat]', '$_POST[dosis]', '$_POST[aturan_pakai]', '$_POST[keterangan]')");

header("Location: index.php");
?>