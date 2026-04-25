<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\PasienController;
use App\Http\Controllers\ResepController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/pasien', [PasienController::class, 'index']);
Route::post('/pasien', [PasienController::class, 'store']);
Route::get('/pasien/{id}', [PasienController::class, 'show']);
Route::put('/pasien/{id}', [PasienController::class, 'update']);
Route::delete('/pasien/{id}', [PasienController::class, 'destroy']);

Route::get('/resep-obat', [ResepObatController::class, 'index']);
Route::post('/resep-obat', [ResepObatController::class, 'store']);
Route::get('/resep-obat/{id}', [ResepObatController::class, 'show']);
Route::put('/resep-obat/{id}', [ResepObatController::class, 'update']);
Route::delete('/resep-obat/{id}', [ResepObatController::class, 'destroy']);