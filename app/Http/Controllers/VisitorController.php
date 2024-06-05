<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Visitor;

class VisitorController extends Controller
{
    public function index()
    {
        // Add a new visitor entry
        $visitor = new Visitor();
        $visitor->save();

        // Get the total number of visitors
        $visitorCount = Visitor::count();

        return view('welcome', ['visitorCount' => $visitorCount]);
    }
}
