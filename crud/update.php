<?php
include 'koneksi.php';

mysqli_query($conn, "
UPDATE resep_obat SET
nama_pasien='$_POST[nama_pasien]',
nama_obat='$_POST[nama_obat]',
dosis='$_POST[dosis]',
aturan_pakai='$_POST[aturan_pakai]',
keterangan='$_POST[keterangan]'
WHERE id=$_POST[id]
");

header("Location: index.php");
?>