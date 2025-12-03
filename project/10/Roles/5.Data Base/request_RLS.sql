-- Эти запросы работают корректно только после установки playnext.user_id и предполагают, что пользователь уже аутентифицирован.--

-- 1. Профиль игрока (выполняется от лица игрока, user_id = 1)
SET playnext.user_id = '1';
SELECT
    u.login AS "Username",
    u.email AS "Email",
    (SELECT COUNT(*) FROM ratings) AS "Rated games",          -- RLS ограничит до своих
    (SELECT COUNT(*) FROM reviews) AS "Reviews written",      -- RLS ограничит до своих
    (SELECT array_length(genres, 1) FROM preferences) AS "Favorite genres",
    (SELECT array_length(favorite_games, 1) FROM preferences) AS "Favorite games"
FROM users u
WHERE u.id = current_user_id();

-- 2. Рекомендации (только свои)
SELECT g.title
FROM recommendations r
JOIN games g ON r.game_id = g.id
ORDER BY r.score DESC
LIMIT 4;  -- RLS вернёт только записи с user_id = current_user_id()

-- 3. Статистика для разработчика (user_id = 2)
SET playnext.user_id = '2';
SELECT
    COUNT(r.id) AS total_ratings,
    ROUND(AVG(r.rating), 1) AS avg_rating,
    COUNT(rv.id) AS total_reviews
FROM games g
LEFT JOIN ratings r ON g.id = r.game_id
LEFT JOIN reviews rv ON g.id = rv.game_id AND rv.is_approved = TRUE
WHERE g.developer_id = current_user_id();  -- RLS + явная фильтрация

-- 4. Модерация (менеджер, user_id = 3)
SET playnext.user_id = '3';
SELECT
    g.title,
    u.login AS developer
FROM games g
JOIN users u ON g.developer_id = u.id
WHERE g.status = 'pending';

-- 5. Системные метрики (только для менеджера)
SELECT metric_name, value FROM system_metrics;  -- RLS разрешит только менеджеру

-- 6. Уведомления (только свои)
SET playnext.user_id = '1';
SELECT message FROM notifications WHERE is_read = FALSE;  -- RLS ограничит до своих