-- Включить RLS для всех защищаемых таблиц
ALTER TABLE preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE moderation_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE interactions ENABLE ROW LEVEL SECURITY;

-- Политики для игроков (player)
CREATE POLICY player_preferences_policy ON preferences
    FOR ALL
    TO PUBLIC
    USING (user_id = current_user_id())
    WITH CHECK (user_id = current_user_id());

CREATE POLICY player_ratings_policy ON ratings
    FOR ALL
    TO PUBLIC
    USING (user_id = current_user_id())
    WITH CHECK (user_id = current_user_id());

CREATE POLICY player_reviews_policy ON reviews
    FOR ALL
    TO PUBLIC
    USING (user_id = current_user_id())
    WITH CHECK (user_id = current_user_id());

CREATE POLICY player_recommendations_policy ON recommendations
    FOR SELECT
    TO PUBLIC
    USING (user_id = current_user_id());

CREATE POLICY player_notifications_policy ON notifications
    FOR ALL
    TO PUBLIC
    USING (user_id = current_user_id())
    WITH CHECK (user_id = current_user_id());

-- Политики для разработчиков (developer)
CREATE POLICY developer_games_policy ON games
    FOR ALL
    TO PUBLIC
    USING (developer_id = current_user_id())
    WITH CHECK (developer_id = current_user_id());

CREATE POLICY developer_game_metadata_policy ON game_metadata
    FOR ALL
    TO PUBLIC
    USING (game_id IN (SELECT id FROM games WHERE developer_id = current_user_id()))
    WITH CHECK (game_id IN (SELECT id FROM games WHERE developer_id = current_user_id()));

CREATE POLICY developer_reports_policy ON reports
    FOR SELECT
    TO PUBLIC
    USING (game_id IN (SELECT id FROM games WHERE developer_id = current_user_id()));

-- Политики для менеджеров (manager)
CREATE POLICY manager_moderation_tasks_policy ON moderation_tasks
    FOR ALL
    TO PUBLIC
    USING (true);

CREATE POLICY manager_reports_policy ON reports
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY manager_system_metrics_policy ON system_metrics
    FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY manager_interactions_policy ON interactions
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Общая политика: все могут читать игры (но не модифицировать)
CREATE POLICY public_games_read_policy ON games
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Общая политика: все могут читать метаданные игр
CREATE POLICY public_game_metadata_read_policy ON game_metadata
    FOR SELECT
    TO PUBLIC
    USING (true);

-- Вспомогательная функция для получения ID текущего пользователя
CREATE OR REPLACE FUNCTION current_user_id()
RETURNS INTEGER AS $$
BEGIN
    RETURN current_setting('playnext.user_id', true)::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- Чтобы использовать current_user_id(), приложение должно устанавливать сессионную переменную после аутентификации:--
-- SET playnext.user_id = '1';  -- ID аутентифицированного пользователя--