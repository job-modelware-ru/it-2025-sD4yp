-- 1. Профиль игрока zxnkxn (точно как в макете)
SELECT
    u.login AS "Username",
    u.email AS "Email",
    (SELECT COUNT(*) FROM ratings WHERE user_id = u.id) AS "Rated games",
    (SELECT COUNT(*) FROM reviews WHERE user_id = u.id) AS "Reviews written",
    (SELECT array_length(genres, 1) FROM preferences WHERE user_id = u.id) AS "Favorite genres",
    (SELECT array_length(favorite_games, 1) FROM preferences WHERE user_id = u.id) AS "Favorite games"
FROM users u
WHERE u.login = 'zxnkxn';

-- 2. Рекомендации для игрока
SELECT g.title
FROM recommendations r
JOIN games g ON r.game_id = g.id
WHERE r.user_id = (SELECT id FROM users WHERE login = 'zxnkxn')
ORDER BY r.score DESC
LIMIT 4;

-- 3. Карточка игры: описание и жанр
SELECT
    g.title,
    gm.description,
    gm.genre
FROM games g
JOIN game_metadata gm ON g.id = gm.game_id
WHERE g.title = 'Hogwarts Legacy';

-- 4. Отзывы к игре (одобренные)
SELECT
    u.login,
    rv.review_text
FROM reviews rv
JOIN users u ON rv.user_id = u.id
WHERE rv.game_id = (SELECT id FROM games WHERE title = 'Hogwarts Legacy')
  AND rv.is_approved = TRUE;

-- 5. Статистика для разработчика: оценки и отзывы
SELECT
    COUNT(r.id) AS total_ratings,
    ROUND(AVG(r.rating), 1) AS avg_rating,
    COUNT(rv.id) AS total_reviews
FROM games g
LEFT JOIN ratings r ON g.id = r.game_id
LEFT JOIN reviews rv ON g.id = rv.game_id AND rv.is_approved = TRUE
WHERE g.title = 'Hogwarts Legacy';

-- 6. Игры на модерации (непромодерированный контент)
SELECT
    g.title,
    u.login AS developer
FROM games g
JOIN users u ON g.developer_id = u.id
WHERE g.status = 'pending';

-- 7. Агрегированные отчёты по предпочтениям игроков
SELECT
    report_type,
    data
FROM reports
WHERE report_type = 'player_behavior';

-- 8. Состояние системы (нагрузка, время отклика)
SELECT
    metric_name,
    value
FROM system_metrics
ORDER BY metric_name;

-- 9. Уведомления для игрока
SELECT message
FROM notifications
WHERE user_id = (SELECT id FROM users WHERE login = 'zxnkxn')
  AND is_read = FALSE;

-- 10. Обновление предпочтений (пример: добавить жанр)
UPDATE preferences
SET genres = array_append(genres, 'Fighting')
WHERE user_id = (SELECT id FROM users WHERE login = 'zxnkxn');

-- 11. Блокировка пользователя (менеджером)
UPDATE users
SET is_active = FALSE
WHERE login = 'zxnkxn';

-- 12. Взаимодействия игрока с играми (просмотры, клики)
SELECT
    g.title,
    i.event_type,
    i.value
FROM interactions i
JOIN games g ON i.game_id = g.id
WHERE i.user_id = (SELECT id FROM users WHERE login = 'zxnkxn')
ORDER BY i.created_at DESC
LIMIT 5;