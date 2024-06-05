<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\VisitorController;

Route::get('/', [VisitorController::class, 'index']);
