<?php
include 'koneksi.php';

$id = $_GET['id'];
$data = mysqli_query($conn, "SELECT * FROM resep_obat WHERE id=$id");
$row = mysqli_fetch_assoc($data);
?>

<h2>Edit Resep Obat</h2>

<form action="update.php" method="POST">
    <input type="hidden" name="id" value="<?= $row['id']; ?>">

    Pasien <br>
    <input type="text" name="nama_pasien" value="<?= $row['nama_pasien']; ?>"><br><br>

    Nama Obat <br>
    <input type="text" name="nama_obat" value="<?= $row['nama_obat']; ?>"><br><br>

    Dosis <br>
    <input type="text" name="dosis" value="<?= $row['dosis']; ?>"><br><br>

    Aturan Pakai <br>
    <input type="text" name="aturan_pakai" value="<?= $row['aturan_pakai']; ?>"><br><br>

    Keterangan <br>
    <textarea name="keterangan"><?= $row['keterangan']; ?></textarea><br><br>

    <button type="submit">Update</button>
</form>