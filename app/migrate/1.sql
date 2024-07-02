ALTER TABLE user_contest_chart_votes ADD `value` REAL NOT NULL DEFAULT 0;
UPDATE user_contest_chart_votes SET value = 1 WHERE vote = 0;
UPDATE user_contest_chart_votes SET vote = 0 WHERE vote = 1;
UPDATE user_contest_chart_votes SET vote = 1 WHERE vote = 2;
