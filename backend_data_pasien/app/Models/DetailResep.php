<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetailResep extends Model
{
    protected $table = 'detail_resep';

    protected $fillable = [
        'resep_id',
        'nama_obat',
        'dosis',
        'jumlah',
        'aturan_pakai'
    ];

    public function resep()
    {
        return $this->belongsTo(ResepObat::class, 'resep_id');
    }
}