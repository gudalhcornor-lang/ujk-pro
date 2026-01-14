<?php

namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PasienController extends Controller
{
    private function formatResponse($data, $code = 200, $status = true)
    {
        return response()->json([
            'code' => (int)$code,
            'status' => $status,
            'data' => $data
        ], $code);
    }

    public function index()
    {
        $data = Pasien::all();
        return $this->formatResponse($data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'no_rm'          => 'required|unique:pasiens,no_rm',
            'nama_pasien'    => 'required',
            'jenis_kelamin'  => 'required|in:L,P',
            'tanggal_lahir'  => 'required|date',
            'umur'           => 'required|integer',
            'alamat'         => 'required',
            'no_hp'          => 'required',
            'keluhan'        => 'nullable',
            'diagnosis'      => 'nullable',
        ]);

        if ($validator->fails()) {
            return $this->formatResponse($validator->errors()->first(), 422, false);
        }

        $pasien = Pasien::create($request->all());
        return $this->formatResponse($pasien, 201);
    }

    public function show($id)
    {
        $pasien = Pasien::find($id);
        if (!$pasien) {
            return $this->formatResponse('Pasien tidak ditemukan', 404, false);
        }

        return $this->formatResponse($pasien);
    }

    public function update(Request $request, $id)
    {
        $pasien = Pasien::find($id);
        if (!$pasien) {
            return $this->formatResponse('Pasien tidak ditemukan', 404, false);
        }

        $validator = Validator::make($request->all(), [
            'nama_pasien'    => 'required',
            'jenis_kelamin'  => 'required|in:L,P',
            'tanggal_lahir'  => 'required|date',
            'umur'           => 'required|integer',
            'alamat'         => 'required',
            'no_hp'          => 'required',
            'keluhan'        => 'nullable',
            'diagnosis'      => 'nullable',
        ]);

        if ($validator->fails()) {
            return $this->formatResponse($validator->errors()->first(), 422, false);
        }

        $pasien->update($request->all());
        return $this->formatResponse($pasien);
    }

    public function destroy($id)
    {
        $pasien = Pasien::find($id);
        if (!$pasien) {
            return $this->formatResponse('Pasien tidak ditemukan', 404, false);
        }

        $pasien->delete();
        return $this->formatResponse('Pasien berhasil dihapus');
    }
}
