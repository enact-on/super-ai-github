---
name: laravel
description: Laravel and PHP development patterns and best practices
license: MIT
compatibility: opencode
---

# Laravel Skill

Comprehensive patterns and best practices for Laravel and PHP development.

## What I Know

### Project Structure

```
app/
├── Http/
│   ├── Controllers/     # Controllers
│   ├── Middleware/      # Middleware
│   ├── Requests/        # Form Requests (validation)
│   └── Resources/       # API Resources
├── Models/              # Eloquent models
├── Services/            # Business logic
├── Exceptions/          # Custom exceptions
└── Helpers/             # Helper functions
```

### Routing

**API Routes**
```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('users', UserController::class);
    Route::prefix('admin')->group(function () {
        Route::apiResource('posts', PostController::class);
    });
});
```

**Web Routes**
```php
// routes/web.php
Route::get('/', [HomeController::class, 'index'])->name('home');
Route::resource('posts', PostController::class);
```

### Controllers

**Best Practice Controller**
```php
<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePostRequest;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\JsonResponse;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::with(['author', 'tags'])
            ->latest()
            ->paginate(20);

        return PostResource::collection($posts);
    }

    public function store(StorePostRequest $request): JsonResponse
    {
        $post = $this->postService->create($request->validated());

        return response()->json([
            'data' => new PostResource($post),
        ], 201);
    }

    public function update(StorePostRequest $request, Post $post): JsonResponse
    {
        $post = $this->postService->update($post, $request->validated());

        return response()->json([
            'data' => new PostResource($post),
        ]);
    }

    public function destroy(Post $post): JsonResponse
    {
        $this->authorize('delete', $post);

        $post->delete();

        return response()->json(null, 204);
    }
}
```

### Services (Business Logic)

**Service Class**
```php
<?php

namespace App\Services;

use App\Models\Post;
use Illuminate\Database\Eloquent\Model;

class PostService
{
    public function create(array $data): Post
    {
        $post = Post::create($data);

        // Handle relationships
        if (isset($data['tags'])) {
            $post->tags()->sync($data['tags']);
        }

        return $post->load(['author', 'tags']);
    }

    public function update(Post $post, array $data): Post
    {
        $post->update($data);

        if (isset($data['tags'])) {
            $post->tags()->sync($data['tags']);
        }

        return $post->load(['author', 'tags']);
    }
}
```

### Models

**Eloquent Model**
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'content',
        'author_id',
        'published_at',
    ];

    protected $casts = [
        'published_at' => 'datetime',
    ];

    protected $hidden = [
        'deleted_at',
    ];

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class)
            ->withTimestamps();
    }

    public function scopePublished($query)
    {
        return $query->whereNotNull('published_at')
            ->where('published_at', '<=', now());
    }

    public function scopeWithTag($query, string $tag)
    {
        return $query->whereHas('tags', function ($q) use ($tag) {
            $q->where('name', $tag);
        });
    }
}
```

### Validation

**Form Request**
```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\ValidationRule;

class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Post::class);
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'content' => ['required', 'string'],
            'tags' => ['array'],
            'tags.*' => ['exists:tags,id'],
            'published_at' => ['nullable', 'date'],
        ];
    }

    public function messages(): array
    {
        return [
            'title.required' => 'A title is required',
            'content.required' => 'Content cannot be empty',
        ];
    }
}
```

### API Resources

**Resource**
```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'excerpt' => Str::limit($this->content, 150),
            'author' => new UserResource($this->whenLoaded('author')),
            'tags' => TagResource::collection($this->whenLoaded('tags')),
            'created_at' => $this->created_at->toIso8601String(),
            'updated_at' => $this->updated_at->toIso8601String(),
        ];
    }
}
```

### Migrations

**Migration**
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('author_id')->constrained('users')->cascadeOnDelete();
            $table->string('title');
            $table->text('content');
            $table->timestamp('published_at')->nullable();
            $table->softDeletes();
            $table->timestamps();

            $table->index(['author_id', 'published_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
```

### Jobs & Queues

**Job Class**
```php
<?php

namespace App\Jobs;

use App\Models\Post;
use App\Services\NotificationService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class PublishPostJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $tries = 3;
    public $timeout = 120;

    public function __construct(
        public Post $post
    ) {}

    public function handle(NotificationService $notification): void
    {
        $this->post->update(['published_at' => now()]);
        $notification->notifyPostPublished($this->post);
    }

    public function failed(\Throwable $exception): void
    {
        \Log::error('Failed to publish post: ' . $exception->getMessage());
    }
}
```

### Events & Listeners

**Event**
```php
<?php

namespace App\Events;

use App\Models\Post;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class PostPublished
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public Post $post
    ) {}
}
```

**Listener**
```php
<?php

namespace App\Listeners;

use App\Events\PostPublished;
use App\Services\SubscriptionService;

class NotifySubscribers
{
    public function __construct(
        private SubscriptionService $subscription
    ) {}

    public function handle(PostPublished $event): void
    {
        $this->subscription->notifyAbout($event->post);
    }
}
```

### Middleware

**Custom Middleware**
```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserHasRole
{
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if (!$request->user()?->hasRole($role)) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return $next($request);
    }
}
```

### Config

**Service Provider**
```php
<?php

namespace App\Providers;

use App\Services\PostService;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->singleton(PostService::class);
    }

    public function boot(): void
    {
        // Blade directives, macros, etc.
    }
}
```

### Testing

**Feature Test**
```php
<?php

namespace Tests\Feature;

use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PostManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_post(): void
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->postJson('/api/posts', [
            'title' => 'Test Post',
            'content' => 'Test content',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.title', 'Test Post');

        $this->assertDatabaseHas('posts', [
            'title' => 'Test Post',
            'author_id' => $user->id,
        ]);
    }
}
```

### Common Patterns

**Repository Pattern (Optional)**
```php
<?php

namespace App\Repositories;

use App\Models\Post;
use Illuminate\Pagination\LengthAwarePaginator;

interface PostRepositoryInterface
{
    public function all(): LengthAwarePaginator;
    public function find(int $id): ?Post;
    public function create(array $data): Post;
    public function update(Post $post, array $data): Post;
    public function delete(Post $post): bool;
}

class EloquentPostRepository implements PostRepositoryInterface
{
    public function all(): LengthAwarePaginator
    {
        return Post::with(['author', 'tags'])
            ->latest()
            ->paginate(20);
    }
    // ... other methods
}
```

### Best Practices

1. **Use Form Requests** for validation (not in controllers)
2. **Use Services** for business logic (not in controllers)
3. **Use API Resources** for consistent responses
4. **Use Route Model Binding** for type-hinted models
5. **Use Eloquent relationships** instead of manual joins
6. **Use migrations** for all schema changes
7. **Use queues** for long-running tasks
8. **Use config** for environment-specific settings

### Common Pitfalls

1. **N+1 queries** → Use eager loading (`with()`)
2. **Fat controllers** → Move logic to services
3. **Direct env() calls** → Use config instead
4. **Mass assignment vulnerabilities** → Use `$fillable` or guarded
5. **Missing foreign key constraints** → Use database constraints

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
