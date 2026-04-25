<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ResepObat extends Model
{
    protected $table = 'resep_obat';

    protected $fillable = [
        'pasien_id',
        'tanggal_resep',
        'nama_dokter',
        'catatan'
    ];

    public function pasien()
    {
        return $this->belongsTo(Pasien::class);
    }

    public function detail()
    {
        return $this->hasMany(DetailResep::class, 'resep_id');
    }
}