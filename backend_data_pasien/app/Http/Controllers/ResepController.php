<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\ResepObat;
use App\Models\DetailResep;

class ResepObatController extends Controller
{
    /**
     * 📖 GET /resep-obat
     * Ambil semua resep + detail
     */
    public function index()
    {
        $data = ResepObat::with('detail')->latest()->get();

        return response()->json([
            'message' => 'List resep obat',
            'data' => $data
        ]);
    }

    /**
     * ➕ POST /resep-obat
     */
    public function store(Request $request)
    {
        $request->validate([
            'pasien_id' => 'required|exists:pasiens,id',
            'tanggal_resep' => 'required|date',
            'nama_dokter' => 'required|string',
            'detail' => 'required|array',
            'detail.*.nama_obat' => 'required|string',
            'detail.*.dosis' => 'required|string',
            'detail.*.jumlah' => 'required|integer',
            'detail.*.aturan_pakai' => 'required|string',
        ]);

        DB::beginTransaction();

        try {
            $resep = ResepObat::create([
                'pasien_id' => $request->pasien_id,
                'tanggal_resep' => $request->tanggal_resep,
                'nama_dokter' => $request->nama_dokter,
                'catatan' => $request->catatan,
            ]);

            foreach ($request->detail as $item) {
                DetailResep::create([
                    'resep_id' => $resep->id,
                    'nama_obat' => $item['nama_obat'],
                    'dosis' => $item['dosis'],
                    'jumlah' => $item['jumlah'],
                    'aturan_pakai' => $item['aturan_pakai'],
                ]);
            }

            DB::commit();

            return response()->json([
                'message' => 'Resep berhasil disimpan',
                'data' => $resep->load('detail')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal menyimpan',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 🔍 GET /resep-obat/{id}
     */
    public function show($id)
    {
        $resep = ResepObat::with('detail')->find($id);

        if (!$resep) {
            return response()->json([
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'data' => $resep
        ]);
    }

    /**
     * ✏️ PUT /resep-obat/{id}
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'pasien_id' => 'required|exists:pasiens,id',
            'tanggal_resep' => 'required|date',
            'nama_dokter' => 'required|string',
            'detail' => 'required|array',
        ]);

        DB::beginTransaction();

        try {
            $resep = ResepObat::findOrFail($id);

            $resep->update([
                'pasien_id' => $request->pasien_id,
                'tanggal_resep' => $request->tanggal_resep,
                'nama_dokter' => $request->nama_dokter,
                'catatan' => $request->catatan,
            ]);

            // 🔥 Hapus detail lama
            DetailResep::where('resep_id', $resep->id)->delete();

            // 🔥 Insert ulang detail
            foreach ($request->detail as $item) {
                DetailResep::create([
                    'resep_id' => $resep->id,
                    'nama_obat' => $item['nama_obat'],
                    'dosis' => $item['dosis'],
                    'jumlah' => $item['jumlah'],
                    'aturan_pakai' => $item['aturan_pakai'],
                ]);
            }

            DB::commit();

            return response()->json([
                'message' => 'Resep berhasil diupdate',
                'data' => $resep->load('detail')
            ]);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'message' => 'Gagal update',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 🗑️ DELETE /resep-obat/{id}
     */
    public function destroy($id)
    {
        try {
            $resep = ResepObat::findOrFail($id);
            $resep->delete();

            return response()->json([
                'message' => 'Resep berhasil dihapus'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menghapus',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}