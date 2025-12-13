-- ===========================================
-- PlayNext: структура базы данных PostgreSQL
-- ===========================================

-- ---------------------------
-- Таблица ролей
-- ---------------------------
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE
);

-- ---------------------------
-- Таблица пользователей
-- ---------------------------
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role_id INT NOT NULL REFERENCES roles(id),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- ---------------------------
-- Таблица авторизационных токенов (для регистрации и авторизации)
-- ---------------------------
CREATE TABLE auth_tokens (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    token TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    revoked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица предпочтений игроков
-- ---------------------------
CREATE TABLE preferences (
    user_id INT PRIMARY KEY REFERENCES users(id),
    genres TEXT[],
    favorite_games TEXT[],
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица игр
-- ---------------------------
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    developer_id INT NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица метаданных игр
-- ---------------------------
CREATE TABLE game_metadata (
    game_id INT PRIMARY KEY REFERENCES games(id),
    description TEXT,
    genre VARCHAR(50),
    system_requirements TEXT,
    target_audience TEXT
);

-- ---------------------------
-- Таблица задач модерации
-- ---------------------------
CREATE TABLE moderation_tasks (
    game_id INT PRIMARY KEY REFERENCES games(id),
    moderator_id INT REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    decision_comment TEXT,
    reviewed_at TIMESTAMP
);

-- ---------------------------
-- Таблица рейтингов
-- ---------------------------
CREATE TABLE ratings (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    game_id INT NOT NULL REFERENCES games(id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, game_id)
);

-- ---------------------------
-- Таблица отзывов
-- ---------------------------
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    game_id INT NOT NULL REFERENCES games(id),
    review_text TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица взаимодействий
-- ---------------------------
CREATE TABLE interactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    game_id INT REFERENCES games(id),
    event_type VARCHAR(30) NOT NULL CHECK (event_type IN ('view','play_time','purchase','click')),
    value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица уведомлений
-- ---------------------------
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    game_id INT REFERENCES games(id),
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ---------------------------
-- Таблица рекомендаций
-- ---------------------------
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    game_id INT NOT NULL REFERENCES games(id),
    score FLOAT NOT NULL CHECK (score BETWEEN 0.0 AND 1.0),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, game_id)
);

-- ---------------------------
-- Таблица отчётов
-- ---------------------------
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,
    game_id INT REFERENCES games(id),
    generated_by INT REFERENCES users(id),
    data JSONB,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Таблица метрик системы
-- ---------------------------
CREATE TABLE system_metrics (
    id SERIAL PRIMARY KEY,
    metric_name VARCHAR(50) NOT NULL,
    value FLOAT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- Индексы для ускорения запросов
-- ---------------------------
CREATE INDEX idx_users_role ON users(role_id);
CREATE INDEX idx_users_email ON users(email);

CREATE INDEX idx_ratings_user ON ratings(user_id);
CREATE INDEX idx_ratings_game ON ratings(game_id);

CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_game ON reviews(game_id);
CREATE INDEX idx_reviews_approved ON reviews(is_approved);

CREATE INDEX idx_interactions_user ON interactions(user_id);
CREATE INDEX idx_interactions_game ON interactions(game_id);
CREATE INDEX idx_interactions_type ON interactions(event_type);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE is_read = FALSE;

CREATE INDEX idx_recommendations_user ON recommendations(user_id);
CREATE INDEX idx_recommendations_score ON recommendations(user_id, score DESC);

CREATE INDEX idx_reports_game ON reports(game_id);
CREATE INDEX idx_reports_type ON reports(report_type);

CREATE INDEX idx_metrics_name ON system_metrics(metric_name);
CREATE INDEX idx_metrics_time ON system_metrics(recorded_at);