<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class SimpleTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_example(): void
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }

    public function test_math_operations()
    {
        $this->assertEquals(4, 2 + 2);
        $this->assertEquals(9, 3 * 3);
        $this->assertEquals(2, 6 / 3);
    }
}
