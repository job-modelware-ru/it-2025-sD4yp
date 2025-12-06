

-- 1. Роли
INSERT INTO roles (name) VALUES
    ('player'),
    ('developer'),
    ('manager');

-- 2. Пользователи
INSERT INTO users (login, email, password_hash, role_id, is_verified, last_login) VALUES
    -- Игрок из макета
    ('zxnkxn', 'st.zinkin@yandex.ru', 'scrypt_hash_123', 1, TRUE, '2025-12-03 14:30:00'),
    -- Разработчик
    ('dev_studioX', 'studiox@games.com', 'scrypt_dev_789', 2, TRUE, '2025-12-02 10:15:00'),
    -- Менеджер платформы
    ('platform_mgr', 'manager@playnext.com', 'scrypt_mgr_456', 3, TRUE, '2025-12-03 09:00:00');

-- 3. Предпочтения игрока (точно как в макете: 12 жанров, 14 игр)
INSERT INTO preferences (user_id, genres, favorite_games) VALUES (
    1,
    ARRAY[
        'Action', 'Adventure', 'RPG', 'Strategy', 'Simulation',
        'Sports', 'Racing', 'Puzzle', 'Platformer', 'Shooter',
        'Co-op', 'Roguelike'
    ],
    ARRAY[
        'Hogwarts Legacy', 'Firewatch', 'Fallout 4', 'Factorio',
        'The Witcher 3', 'Skyrim', 'CS2', 'DOOM', 'Metroid Dread',
        'Stardew Valley', 'Terraria', 'Hades', 'Dead Cells', 'Slay the Spire'
    ]
);

-- 4. Игры
INSERT INTO games (title, developer_id, status, published_at) VALUES
    ('Hogwarts Legacy', 2, 'approved', '2025-11-01 10:00:00'),
    ('Firewatch', 2, 'approved', '2025-10-15 14:00:00'),
    ('Fallout 4', 2, 'approved', '2025-09-20 09:00:00'),
    ('Factorio', 2, 'approved', '2025-08-10 16:00:00'),
    ('Cyber Quest', 2, 'pending', NULL),
    ('Dark Realm', 2, 'rejected', NULL);

-- 5. Метаданные игр (с данными из макета)
INSERT INTO game_metadata (game_id, description, genre, system_requirements, target_audience) VALUES
    (1, 'It''s an open-world role-playing game. Now you can control your actions and become the central character of your own adventures in the magical world.', 'RPG', 'Windows 10, 8GB RAM, GTX 1060', '16+'),
    (2, 'A narrative adventure game set in the Wyoming wilderness.', 'Adventure', 'Windows 7+, 4GB RAM', '13+'),
    (3, 'An action RPG set in a post-apocalyptic world.', 'RPG', 'Windows 7+, 8GB RAM', '17+'),
    (4, 'Build factories, automate production, fight aliens.', 'Simulation', 'Windows 7+, 4GB RAM', '10+');

-- 6. Задачи модерации
INSERT INTO moderation_tasks (game_id, moderator_id, status, decision_comment, reviewed_at) VALUES
    (1, 3, 'approved', 'Соответствует требованиям', '2025-11-01 09:30:00'),
    (2, 3, 'approved', 'Одобрено', '2025-10-15 13:45:00'),
    (3, 3, 'approved', 'Одобрено', '2025-09-20 08:50:00'),
    (4, 3, 'approved', 'Одобрено', '2025-08-10 15:30:00'),
    (6, 3, 'rejected', 'Нарушение авторских прав', '2025-11-20 11:00:00');

-- 7. 27 оценок для игрока zxnkxn (rating 1-5)
-- Создаём временные данные для 27 записей
INSERT INTO ratings (user_id, game_id, rating, created_at)
SELECT 
    1 AS user_id,
    g.id AS game_id,
    (3 + (random() * 3)::INT) AS rating, -- случайный рейтинг 3–5
    '2025-12-01'::DATE + (i * '1 hour'::INTERVAL) AS created_at
FROM games g
CROSS JOIN generate_series(1, 10) AS i
WHERE g.status = 'approved'
LIMIT 27;

-- 8. 8 отзывов (как в макете + дополнительные)
INSERT INTO reviews (user_id, game_id, review_text, is_approved, created_at) VALUES
    (1, 1, 'The game is great... but why don''t I have a nose after choosing a character?', TRUE, '2025-12-01 10:00:00'),
    (1, 1, 'Trolls attack suddenly, like the Russian frost in 1812.', TRUE, '2025-12-01 11:30:00'),
    (1, 1, 'Hogwarts completely ignores my laws...', TRUE, '2025-12-01 14:20:00'),
    (1, 2, 'Beautiful story and atmosphere!', TRUE, '2025-12-01 16:45:00'),
    (1, 3, 'Too many bugs, but world is amazing.', TRUE, '2025-12-02 09:10:00'),
    (1, 4, 'Addictive gameplay, great for engineers.', TRUE, '2025-12-02 13:20:00'),
    (1, 1, 'Best RPG of the decade!', TRUE, '2025-12-02 18:05:00'),
    (1, 2, 'Short but emotional journey.', TRUE, '2025-12-03 08:30:00');

-- 9. Взаимодействия (просмотры, клики)
INSERT INTO interactions (user_id, game_id, event_type, value, created_at) VALUES
    (1, 1, 'view', NULL, '2025-12-01 09:50:00'),
    (1, 1, 'play_time', '3600', '2025-12-01 12:00:00'), -- 1 час
    (1, 2, 'view', NULL, '2025-12-01 15:30:00'),
    (1, 3, 'view', NULL, '2025-12-02 08:45:00'),
    (1, 4, 'click', NULL, '2025-12-02 12:10:00');

-- 10. Рекомендации
INSERT INTO recommendations (user_id, game_id, score, generated_at) VALUES
    (1, 1, 0.95, '2025-12-03 08:00:00'),
    (1, 2, 0.88, '2025-12-03 08:00:00'),
    (1, 3, 0.72, '2025-12-03 08:00:00'),
    (1, 4, 0.65, '2025-12-03 08:00:00');

-- 11. Уведомления
INSERT INTO notifications (user_id, game_id, message, is_read, created_at) VALUES
    (1, 1, 'Новая игра "Hogwarts Legacy" доступна!', FALSE, '2025-11-01 10:05:00'),
    (1, 4, 'Вам может понравиться "Factorio"', FALSE, '2025-08-10 16:10:00');

-- 12. Отчёты
INSERT INTO reports (report_type, game_id, generated_by, data, generated_at) VALUES
    ('game_stats', 1, 3, '{"views": 150, "avg_rating": 4.2, "reviews": 27}', '2025-12-03 07:00:00'),
    ('player_behavior', NULL, 3, '{"active_players": 1200, "top_genre": "RPG"}', '2025-12-03 07:30:00');

-- 13. Метрики системы
INSERT INTO system_metrics (metric_name, value, recorded_at) VALUES
    ('response_time_ms', 120.5, '2025-12-03 14:00:00'),
    ('active_connections', 842, '2025-12-03 14:00:00'),
    ('cpu_load_percent', 67.3, '2025-12-03 14:00:00');

-- 14. Токены аутентификации (для демонстрации)
-- Пример токена подтверждения email
INSERT INTO auth_tokens (user_id, token, expires_at, revoked, created_at)
VALUES (
    1,
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxxx',
    '2025-12-04 14:30:00',
    FALSE,
    '2025-12-03 14:30:00'
);

