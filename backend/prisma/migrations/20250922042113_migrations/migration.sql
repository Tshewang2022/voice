-- DropIndex
DROP INDEX "public"."BlockedUser_user_id_key";

-- CreateIndex
CREATE INDEX "BlockedUser_user_id_idx" ON "public"."BlockedUser"("user_id");
