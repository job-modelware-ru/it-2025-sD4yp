from graphviz import Digraph
import os

# Path to the script directory (PlayNext/src)
script_dir = os.path.dirname(os.path.abspath(__file__))

# Path to output directory (PlayNext/output)
project_root = os.path.dirname(script_dir)  # src -> PlayNext
output_dir = os.path.join(project_root, "output")

# Creating the output folder if it doesn't exist.
os.makedirs(output_dir, exist_ok=True)

# Create graph
dot = Digraph("BPMN_PlayNext_RU", format="png")
dot.attr(rankdir="LR", fontsize="10")

# --- Styles ---
event = {"shape": "circle", "style": "filled", "color": "blue", "fontcolor": "white"}
intermediate_event = {"shape": "circle", "style": "filled", "color": "blue", "fontcolor": "white"}
end_event = {"shape": "circle", "style": "filled", "color": "blue", "penwidth": "3", "fontcolor": "white"}
task = {"shape": "rect", "style": "rounded,filled", "color": "green", "fontcolor": "black"}
gateway = {"shape": "diamond", "style": "filled", "color": "red", "fontcolor": "white"}

# --- Nodes (Player) ---
dot.node("player_start", "Начало: Игрок открывает платформу", **event)
dot.node("login", "Регистрация / Вход", **task)
dot.node("preferences", "Ввод предпочтений", **task)
dot.node("received_recs", "Получены рекомендации", **intermediate_event)
dot.node("browse", "Просмотр рекомендаций", **task)
dot.node("interested?", "Заинтересован?", **gateway)
dot.node("open_game", "Открыть игру / Купить / В желаемое", **task)
dot.node("rate", "Оценить рекомендацию\n(Нравится / Не нравится)", **task)
dot.node("player_end", "Конец: Сессия завершена", **end_event)

# --- Nodes (System) ---
dot.node("request", "Запрос получен", **intermediate_event)
dot.node("analyze", "Анализ данных игрока", **task)
dot.node("update?", "Нужно обновить модель?", **gateway)
dot.node("train", "Обучить модель", **task)
dot.node("generate", "Сгенерировать рекомендации", **task)
dot.node("send", "Отправить рекомендации игроку", **intermediate_event)
dot.node("feedback", "Получить отзыв", **intermediate_event)
dot.node("update_profile", "Обновить профиль игрока", **task)
dot.node("collect_stats", "Собрать статистику по играм", **task)
dot.node("report", "Сформировать отчёт", **task)
dot.node("system_end", "Конец: Процесс завершён", **end_event)

# --- Nodes (Developer) ---
dot.node("add_game", "Добавить / обновить игру", **task)
dot.node("valid?", "Данные верны?", **gateway)
dot.node("publish", "Опубликовать игру", **task)
dot.node("analytics", "Получить аналитику", **task)

# --- Nodes (Manager) ---
dot.node("moderation_request", "Запрос модерации", **intermediate_event)
dot.node("moderation", "Модерировать контент", **task)
dot.node("approve?", "Утвердить?", **gateway)
dot.node("notify_dev", "Уведомить разработчика", **task)

# --- Flows (yellow arrows) ---
flow = {"color": "gold", "fontcolor": "black"}

# Player
dot.edge("player_start", "login", label="открыть", **flow)
dot.edge("login", "preferences", label="ввести данные", **flow)
dot.edge("preferences", "request", label="отправить предпочтения", **flow)
dot.edge("send", "received_recs", label="список рекомендаций", **flow)
dot.edge("received_recs", "browse", **flow)
dot.edge("browse", "interested?", **flow)
dot.edge("interested?", "open_game", label="Да", **flow)
dot.edge("interested?", "rate", label="Нет", **flow)
dot.edge("rate", "feedback", label="отзыв игрока", **flow)
dot.edge("open_game", "player_end", label="покупка / в желаемое", **flow)
dot.edge("rate", "player_end", label="завершение", **flow)

# System
dot.edge("request", "analyze", **flow)
dot.edge("analyze", "update?", **flow)
dot.edge("update?", "train", label="Да", **flow)
dot.edge("update?", "generate", label="Нет", **flow)
dot.edge("train", "generate", **flow)
dot.edge("generate", "send", **flow)
dot.edge("feedback", "update_profile", **flow)
dot.edge("update_profile", "collect_stats", **flow)
dot.edge("collect_stats", "report", **flow)
dot.edge("report", "analytics", **flow)
dot.edge("report", "system_end", **flow)

# Developer
dot.edge("add_game", "valid?", **flow)
dot.edge("valid?", "publish", label="Да", **flow)
dot.edge("valid?", "moderation_request", label="Нет", **flow)
dot.edge("analytics", "add_game", label="оптимизация", **flow)

# Manager
dot.edge("moderation_request", "moderation", **flow)
dot.edge("moderation", "approve?", **flow)
dot.edge("approve?", "publish", label="Да", **flow)
dot.edge("approve?", "notify_dev", label="Нет", **flow)
dot.edge("notify_dev", "add_game", **flow)

# --- Save in output directory ---
output_path = os.path.join(output_dir, "PlayNext_BPMN")
dot.render(output_path, cleanup=True)

print(f"Диаграмма сохранена как {output_path}.png")

