<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    private function formatResponse($data, $code = 200, $status = true)
    {
        return response()->json([
            'code' => (int)$code,
            'status' => $status ? true : false,
            'data' => $data
        ], $code);
    }

    /// =====================
    /// REGISTER
    /// =====================
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed'
        ]);

        if ($validator->fails()) {
            return $this->formatResponse(
                $validator->errors()->first(),
                422,
                false
            );
        }

        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        return $this->formatResponse(
            "Registrasi berhasil",
            201
        );
    }

    /// =====================
    /// LOGIN
    /// =====================
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email'    => 'required|email',
            'password' => 'required'
        ]);

        $user = User::where('email', $credentials['email'])->first();

        if (!$user || !Hash::check($credentials['password'], $user->password)) {
            return $this->formatResponse(
                'Email atau password salah',
                401,
                false
            );
        }

        $token = $user->createToken('api-token')->plainTextToken;

        return $this->formatResponse([
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
            ]
        ], 200);
    }
}
