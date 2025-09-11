-- CreateTable
CREATE TABLE "public"."Users" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(320) NOT NULL,
    "first_name" VARCHAR(50) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "phone" VARCHAR(15) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "is_online" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(0) NOT NULL,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AccountSettings" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "is_account_deactivated" BOOLEAN NOT NULL DEFAULT false,
    "is_darkmode" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "AccountSettings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_email_key" ON "public"."Users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Users_phone_key" ON "public"."Users"("phone");

-- CreateIndex
CREATE INDEX "Users_is_online_idx" ON "public"."Users"("is_online");

-- CreateIndex
CREATE INDEX "Users_phone_idx" ON "public"."Users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "AccountSettings_user_id_key" ON "public"."AccountSettings"("user_id");

-- AddForeignKey
ALTER TABLE "public"."AccountSettings" ADD CONSTRAINT "AccountSettings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
