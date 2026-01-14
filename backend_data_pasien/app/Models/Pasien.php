<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pasien extends Model
{
    use HasFactory;

    protected $table = 'pasiens';

    protected $fillable = [
        'no_rm',
        'nama_pasien',
        'jenis_kelamin',
        'tanggal_lahir',
        'umur',
        'alamat',
        'no_hp',
        'keluhan',
        'diagnosis'
    ];
}
