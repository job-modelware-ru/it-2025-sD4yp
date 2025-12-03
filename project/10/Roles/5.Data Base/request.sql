-- Запросы


-- Регистрация нового пользователя
-- Проверка уникальности email/login, хэширование пароля
INSERT INTO users (login, email, password_hash, role_id)
VALUES ('eve', 'eve@example.com', 'hashed_pwd5', 1);

-- Авторизация
-- Проверка login/email и password_hash
SELECT * FROM users
WHERE login = 'alice' AND password_hash = 'hashed_pwd1' AND is_active = TRUE;

-- Получить рекомендации для игрока
SELECT r.user_id, r.game_id, g.title, r.score
FROM recommendations r
JOIN games g ON r.game_id = g.id
WHERE r.user_id = 1
ORDER BY r.score DESC;

-- Получить уведомления игрока
SELECT * FROM notifications
WHERE user_id = 1 AND is_read = FALSE;

-- Получить рейтинг и отзывы игры
SELECT g.title, r.rating, rev.review_text
FROM games g
LEFT JOIN ratings r ON g.id = r.game_id
LEFT JOIN reviews rev ON g.id = rev.game_id
WHERE g.id = 1;

-- Добавление нового отзыва игроком
INSERT INTO reviews (user_id, game_id, review_text)
VALUES (1, 2, 'Loved this game!');

-- Добавление взаимодействия
INSERT INTO interactions (user_id, game_id, event_type, value)
VALUES (1, 2, 'play_time', '45');

-- Обновление прочитанного уведомления
UPDATE notifications
SET is_read = TRUE
WHERE id = 1;

-- Получение списка игр разработчика
SELECT g.id, g.title, g.status
FROM games g
WHERE g.developer_id = 3;

-- Статистика по игре
SELECT g.title, COUNT(r.id) AS rating_count, AVG(r.rating) AS avg_rating,
       COUNT(rev.id) AS review_count
FROM games g
LEFT JOIN ratings r ON g.id = r.game_id
LEFT JOIN reviews rev ON g.id = rev.game_id
WHERE g.id = 1
GROUP BY g.title;