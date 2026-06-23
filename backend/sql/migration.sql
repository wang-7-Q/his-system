-- ============================================================
-- HIS 教学项目数据迁移脚本（幂等 — 可重复执行）
-- ============================================================

-- 1. 药品信息表：添加库存列（MySQL 8.0+ 语法）
--    MariaDB 将 IF NOT EXISTS 替换为：先 SHOW COLUMNS 再 ALTER
ALTER TABLE drug_info ADD COLUMN IF NOT EXISTS stock INT DEFAULT 1000 COMMENT '库存数量';

-- 2. 初始化现有药品库存（新增列默认1000，但旧数据可能为NULL）
UPDATE drug_info SET stock = 1000 WHERE stock IS NULL;

-- 3. 员工密码迁移模板
--    使用应用内 PasswordUtil.encode("原始密码") 生成BCrypt哈希值后逐个替换
--    UPDATE employee SET password = '<BCRYPT_HASH>' WHERE id = ?;
