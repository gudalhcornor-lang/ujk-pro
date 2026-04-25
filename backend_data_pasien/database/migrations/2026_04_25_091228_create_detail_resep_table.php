<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('detail_resep', function (Blueprint $table) {
            $table->id();
            $table->foreignId('resep_id')->constrained('resep_obat')->onDelete('cascade');
            $table->string('nama_obat');
            $table->string('dosis'); // contoh: 3x sehari
            $table->integer('jumlah');
            $table->string('aturan_pakai'); // sebelum/sesudah makan
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_resep');
    }
};
