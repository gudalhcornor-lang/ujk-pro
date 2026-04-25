<?php include 'koneksi.php'; ?>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Resep Obat</title>
    <style>
        body { font-family: Arial; background:#f4f6f9; padding:20px; }
        .container { max-width:1000px; margin:auto; }

        table { width:100%; border-collapse:collapse; background:white; }
        th, td { padding:12px; border-bottom:1px solid #ddd; }
        th { background:#eee; }

        .btn { padding:6px 10px; border:none; cursor:pointer; border-radius:5px; }
        .edit { background:blue; color:white; }
        .hapus { background:red; color:white; }

        .tambah {
            display:inline-block;
            margin-bottom:10px;
            padding:10px 15px;
            background:green;
            color:white;
            text-decoration:none;
            border-radius:5px;
        }
    </style>
</head>
<body>

<div class="container">

<h2>💊 Dashboard Resep Obat</h2>

<a href="tambah.php" class="tambah">+ Tambah Resep</a>

<table>
    <tr>
        <th>Pasien</th>
        <th>Obat</th>
        <th>Dosis</th>
        <th>Aturan Pakai</th>
        <th>Keterangan</th>
        <th>Aksi</th>
    </tr>

<?php
$data = mysqli_query($conn, "SELECT * FROM resep_obat");

while ($row = mysqli_fetch_assoc($data)) {
?>

<tr>
    <td><?= $row['nama_pasien']; ?></td>
    <td><?= $row['nama_obat']; ?></td>
    <td><?= $row['dosis']; ?></td>
    <td><?= $row['aturan_pakai']; ?></td>
    <td><?= $row['keterangan']; ?></td>
    <td>
        <a href="edit.php?id=<?= $row['id']; ?>">
            <button class="btn edit">Edit</button>
        </a>

        <a href="hapus.php?id=<?= $row['id']; ?>" onclick="return confirm('Hapus data?')">
            <button class="btn hapus">Hapus</button>
        </a>
    </td>
</tr>

<?php } ?>

</table>

</div>

</body>
</html>