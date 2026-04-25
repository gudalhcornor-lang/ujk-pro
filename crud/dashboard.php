<?php include 'koneksi.php'; ?>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Resep</title>
    <style>
        body { font-family: Arial; background:#f4f6f9; padding:20px; }
        .container { max-width:900px; margin:auto; }
        table { width:100%; border-collapse:collapse; background:white; }
        th, td { padding:12px; border-bottom:1px solid #ddd; }
        th { background:#eee; }
        .badge { padding:5px 10px; border-radius:5px; color:white; font-size:12px; }
        .Mudah { background:green; }
        .Sedang { background:orange; }
        .Sulit { background:red; }

        .btn { padding:5px 10px; border:none; cursor:pointer; border-radius:5px; }
        .hapus { background:red; color:white; }
    </style>
</head>
<body>

<div class="container">
    <h2>🍽️ Dashboard Resep Masakan</h2>

    <table>
        <tr>
            <th>Nama</th>
            <th>Kategori</th>
            <th>Waktu</th>
            <th>Tingkat</th>
            <th>Aksi</th>
        </tr>

        <?php
        $data = mysqli_query($conn, "SELECT * FROM resep");

        while ($row = mysqli_fetch_assoc($data)) {
        ?>
        <tr>
            <td><?= $row['nama']; ?></td>
            <td><?= $row['kategori']; ?></td>
            <td><?= $row['waktu']; ?></td>
            <td>
                <span class="badge <?= $row['tingkat']; ?>">
                    <?= $row['tingkat']; ?>
                </span>
            </td>
            <td>
                <a href="hapus.php?id=<?= $row['id']; ?>" 
                   onclick="return confirm('Hapus resep ini?')">
                   <button class="btn hapus">Hapus</button>
                </a>
            </td>
        </tr>
        <?php } ?>

    </table>
</div>

</body>
</html>