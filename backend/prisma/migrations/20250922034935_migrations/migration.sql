-- CreateTable
CREATE TABLE "public"."BlockedUser" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "phone" VARCHAR(15) NOT NULL,

    CONSTRAINT "BlockedUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ContactList" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "first_name" VARCHAR(50) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "phone" VARCHAR(15) NOT NULL,

    CONSTRAINT "ContactList_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "BlockedUser_phone_idx" ON "public"."BlockedUser"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "BlockedUser_user_id_key" ON "public"."BlockedUser"("user_id");

-- CreateIndex
CREATE INDEX "ContactList_user_id_idx" ON "public"."ContactList"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "ContactList_user_id_key" ON "public"."ContactList"("user_id");
