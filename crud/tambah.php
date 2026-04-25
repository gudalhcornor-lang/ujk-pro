<!DOCTYPE html>
<html>
<head>
    <title>Tambah Resep Obat</title>
</head>
<body>

<h2>➕ Tambah Resep Obat</h2>

<form action="simpan.php" method="POST">
    Pasien <br>
    <input type="text" name="nama_pasien"><br><br>

    Nama Obat <br>
    <input type="text" name="nama_obat"><br><br>

    Dosis <br>
    <input type="text" name="dosis"><br><br>

    Aturan Pakai <br>
    <input type="text" name="aturan_pakai"><br><br>

    Keterangan <br>
    <textarea name="keterangan"></textarea><br><br>

    <button type="submit">Simpan</button>
</form>

</body>
</html>